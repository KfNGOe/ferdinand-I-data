<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:uibk="http://igwee.uibk.ac.at/custom/ns"
    exclude-result-prefixes="xs uibk tei"
    version="2.0">
    
    <xsl:param name="fromToPattern">^(.*?)\s+an\s+(.*?)$</xsl:param><!-- e.g. Maximilian I. an Ferdinand. -->
    <xsl:param name="editionStmt"><edition><date when="2014-03-25" />Online Edition Test: Herrscher Korrespondenz</edition></xsl:param>
    <xsl:param name="publicationStmt"><p>Testveröffentlichung Herrscher Korrespondenz</p></xsl:param>
    <xsl:variable name="metadata">
        <xsl:call-template name="getMetadata"/><!-- e.g. ... <uibk:date>1514 Juli 21. Gmunden.</uibk:date> -->
    </xsl:variable>
    
    <xsl:output method="xml" indent="no"/>
    
    <xsl:template match="/" mode="RHconvertMetadata">
        <xsl:apply-templates mode="insertMetadata"/>
    </xsl:template>
    
    <xsl:template match="tei:fileDesc/tei:titleStmt" mode="insertMetadata">
        <titleStmt>
            <title><persName role="sender"><xsl:value-of select="$metadata/uibk:metadata/uibk:sender"/></persName>
                <xsl:text> an </xsl:text>
                <persName role="recipient"><xsl:value-of select="$metadata/uibk:metadata/uibk:recipient"/></persName>
                <xsl:text>, </xsl:text>
                <date><xsl:value-of select="$metadata/uibk:metadata/uibk:date"/><!-- e.g. 1514 Juli 21. Gmunden. --></date></title>
            <author><xsl:value-of select="$metadata/uibk:metadata/uibk:sender"/></author>
        </titleStmt>
    </xsl:template>
    <xsl:template match="tei:fileDesc/tei:sourceDesc" mode="insertMetadata">
        <sourceDesc>
            <xsl:apply-templates mode="insertMetadata"/>
            <p>Document ID: <idno><xsl:value-of select="$metadata/uibk:metadata/uibk:id"/></idno></p>
        </sourceDesc>
    </xsl:template>
    <xsl:template match="tei:editionStmt" mode="insertMetadata">
        <editionStmt>
            <xsl:copy-of select="$editionStmt"/>
        </editionStmt>
    </xsl:template>
    <xsl:template match="tei:publicationStmt" mode="insertMetadata">
        <publicationStmt>
            <xsl:copy-of select="$publicationStmt"/>
        </publicationStmt>
    </xsl:template>
    <xsl:template match="tei:revisionDesc/tei:listChange" mode="insertMetadata">
        <listChange>
            <xsl:apply-templates mode="insertMetadata"/>
            <change><date><xsl:value-of select="current-dateTime()"/></date><name>CONV_METADATA</name></change>
        </listChange>
    </xsl:template>
    <xsl:template match="@*|*|text()|comment()" mode="insertMetadata">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="insertMetadata"/>
            <xsl:apply-templates mode="insertMetadata"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="getMetadata">
        <xsl:variable name="fromToDate"><!-- e.g. ... <uibk:date>1514 Juli 21. Gmunden.</uibk:date> -->
            <xsl:call-template name="getFromToDate"/>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:text>Von </xsl:text>
            <xsl:value-of select="$fromToDate//uibk:from"/>
            <xsl:text> an </xsl:text>
            <xsl:value-of select="$fromToDate//uibk:to"/>
        </xsl:variable>
        <xsl:variable name="id">
            <xsl:call-template name="getFirstPara"/>
        </xsl:variable>
        <uibk:metadata>
            <uibk:sender><xsl:value-of select="$fromToDate//uibk:from"/></uibk:sender>
            <uibk:recipient><xsl:value-of select="$fromToDate//uibk:to"/></uibk:recipient>
            <uibk:date><xsl:value-of select="$fromToDate//uibk:date"/></uibk:date><!-- e.g. <uibk:date>1514 Juli 21. Gmunden.</uibk:date> -->
            <uibk:id><xsl:value-of select="$id"/></uibk:id>
            <uibk:title><xsl:value-of select="$title"/></uibk:title>
        </uibk:metadata>
    </xsl:template>
    
    <xsl:template name="getFirstPara">
        <xsl:value-of select="(//tei:body/descendant::tei:p[string(.)!=''])[1]"/>
    </xsl:template>
    
    <xsl:template name="getFromToDate">
        <xsl:choose>
            <xsl:when test="//tei:body//tei:table">
                <xsl:variable name="table" select="//tei:body//tei:table[1]"/>
                <xsl:choose>
                    <xsl:when test="count($table//tei:cell) = 2">
                        <xsl:variable name="title" select="string($table/tei:row[1]/tei:cell[1])"/><!-- e.g. Maximilian I. an Ferdinand. -->
                        <xsl:choose>
                            <xsl:when test="matches($title, $fromToPattern)">
                                <xsl:analyze-string select="$title" regex="{$fromToPattern}">
                                    <xsl:matching-substring>
                                        <uibk:fromToDate>
                                            <uibk:from><xsl:value-of select="regex-group(1)"/></uibk:from>
                                            <uibk:to><xsl:value-of select="regex-group(2)"/></uibk:to>
                                            <uibk:date><xsl:value-of select="$table/tei:row[1]/tei:cell[2]"/><!-- e.g. 1514 Juli 21. Gmunden. --></uibk:date>
                                        </uibk:fromToDate>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <uibk:fromToDate>
                                            <uibk:from>UNKNOWN</uibk:from>
                                            <uibk:to>UNKNOWN</uibk:to>
                                            <uibk:date>UNKNOWN</uibk:date>
                                        </uibk:fromToDate>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <uibk:fromToDate>
                            <uibk:from>UNKNOWN</uibk:from>
                            <uibk:to>UNKNOWN</uibk:to>
                            <uibk:date>UNKNOWN</uibk:date>
                        </uibk:fromToDate>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>No Table found.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>