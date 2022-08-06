<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:uibk="http://www.uibk.ac.at/igwee/ns"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei uibk" version="2.0">

    <xsl:output method="xml" indent="no"/>

    <xsl:variable name="headerInfo">
        <xsl:variable name="letterHeader">
            <xsl:choose>
                <xsl:when test="//tei:div[@type='letter_header']">
                    <xsl:copy-of select="//*[parent::tei:div[@type='letter_header']]"/>
                </xsl:when>
                <xsl:when test="//tei:table">
                    <xsl:copy-of select="//tei:p[following-sibling::tei:table]"/>
                    <xsl:copy-of select="//tei:table"></xsl:copy-of>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <uibk:headerInfo>
            <uibk:title>
                <xsl:choose>
                    <xsl:when test="$letterHeader/tei:p[1]/matches(normalize-space(),'^(\*\s*)?A?(\s*\*\s*)?\d+\.?(\s*[A-Za-z]+\.)?$')">
                        <xsl:if test="starts-with($letterHeader/tei:p[1], '*')">
                            <xsl:attribute name="inferred">yes</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(string($letterHeader/tei:p[1]))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>No Title Information found</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </uibk:title>
            <xsl:variable name="metadataLine1">
                <xsl:choose>
                    <xsl:when test="count($letterHeader/tei:table)=1 and count($letterHeader/tei:table//tei:cell)=2">
                        <xsl:value-of select="($letterHeader/tei:table//tei:cell)[1]/string()"/>
                    </xsl:when>
                    <xsl:when test="count($letterHeader/tei:table)=1 and count($letterHeader/tei:table//tei:cell)=1 and
                        count($letterHeader/tei:p) &gt; 1">
                        <xsl:value-of select="$letterHeader/tei:p[not(following-sibling::tei:p)]/string()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text></xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <uibk:sender>
                <xsl:choose>
                    <xsl:when test="matches($metadataLine1, '^.+\s+an\s+.+$')">
                        <xsl:analyze-string select="$metadataLine1" regex="^(\*\s*)?(.+)\s+an\s+(.+)$">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(2))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>UNKNOWN</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </uibk:sender>
            <uibk:recipient>
                <xsl:choose>
                    <xsl:when test="matches($metadataLine1, '^.+\s+an\s+.+$')">
                        <xsl:analyze-string select="$metadataLine1" regex="^(.+)\s+an\s+(.+)$">
                            <xsl:matching-substring>
                                <xsl:variable name="recipientFullText" select="normalize-space(regex-group(2))"/>
                                <xsl:choose>
                                    <xsl:when test="matches($recipientFullText, '^.*[A-Z]\.$')">
                                        <xsl:value-of select="$recipientFullText"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="replace($recipientFullText, '\.$', '')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>UNKNOWN</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </uibk:recipient>

            <xsl:variable name="metadataLine2">
                <xsl:choose>
                    <xsl:when test="count($letterHeader/tei:table)=1 and count($letterHeader/tei:table//tei:cell)=2">
                        <xsl:value-of select="($letterHeader/tei:table//tei:cell)[2]/string()"/>
                    </xsl:when>
                    <xsl:when test="count($letterHeader/tei:table)=1 and count($letterHeader/tei:table//tei:cell)=1">
                        <xsl:value-of select="($letterHeader/tei:table//tei:cell)[1]/string()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text></xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="metadataLine2WithoutBrackets" select="replace($metadataLine2, '[\[\]()?]', '')"/>

            <!-- <xsl:variable name="dates" select="uibk:dateparser($metadataLine2WithoutBrackets,'de[full-ymd]')"/> -->
            <!-- RH start -->
            <xsl:variable name="dates" select="substring-before($metadataLine2WithoutBrackets,'. ')"/>
            <xsl:variable name="places" select="substring-before(substring-after($metadataLine2WithoutBrackets,'. '), '.')"/>
            <!-- RH end
            substring-after($metadataLine2WithoutBrackets,". ") -->
            <uibk:dating>
                <!-- <xsl:choose>
                    <xsl:when test="$dates/uibk:date">
                        <xsl:variable name="firstDate" select="($dates/uibk:date)[1]"/>
                        <xsl:if test="$firstDate/@notBefore">
                            <xsl:attribute name="notBefore" select="$firstDate/@notBefore"/>
                        </xsl:if>
                        <xsl:if test="$firstDate/@notAfter">
                            <xsl:attribute name="notAfter" select="$firstDate/@notAfter"/>
                        </xsl:if>
                        <xsl:if test="$firstDate/@parsed">
                            <xsl:attribute name="parsed" select="$firstDate/@parsed"/>
                        </xsl:if>
                        <xsl:value-of select="$firstDate"/>
                    </xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                </xsl:choose> 
                -->
                <xsl:value-of select="$dates"/>
            </uibk:dating>
            <uibk:placeName>
                <!-- 
                <xsl:choose>
                    <xsl:when test="$dates/uibk:date">
                        <xsl:variable name="lastPart" select="$dates/text()[not(following-sibling::text()) and not(following-sibling::uibk:date)]"/>
                        <xsl:message>last part for <xsl:copy-of select="$letterHeader/tei:p"/>
:                        <xsl:copy-of select="$lastPart"/>
                    </xsl:message>
                    <xsl:analyze-string select="normalize-space($lastPart)" regex="(\W*)([^-\[\]—().;+0-9,]+)\W*">
                        <xsl:matching-substring>
                            <xsl:variable name="placeNameFull" select="normalize-space(regex-group(2))"/>
                            <xsl:choose>
                                <xsl:when test="matches($placeNameFull, '^.*[A-Z]\.$')">
                                    <xsl:value-of select="$placeNameFull"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="replace($placeNameFull, '\.$', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose> 
            -->
                <xsl:value-of select="$places"/>
            </uibk:placeName>

        </uibk:headerInfo>
    </xsl:variable>

    <xsl:template match="@*|tei:*|text()" mode="RHaddMetadata">
        <xsl:copy>
            <xsl:apply-templates mode="RHaddMetadata" select="@*"/>
            <xsl:apply-templates mode="RHaddMetadata"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/" mode="RHaddMetadata">
        <xsl:apply-templates mode="RHaddMetadata"/>
    </xsl:template>

    <xsl:template match="tei:titleStmt" mode="RHaddMetadata">
        <xsl:copy>
            <title type="main">
                <xsl:value-of select="$headerInfo//uibk:title"/>
            </title>
            <xsl:if test="$headerInfo//uibk:sender!='UNKNOWN'">
                <title type="sub">
                    <persName role="sender">
                        <xsl:value-of select="$headerInfo//uibk:sender"/>
                    </persName>
                    <xsl:text> an </xsl:text>
                    <persName role="recipient">
                        <xsl:value-of select="$headerInfo//uibk:recipient"/>
                    </persName>
                    <xsl:text>, </xsl:text>
                    <date>
                        <xsl:if test="$headerInfo//uibk:dating/@notBefore">
                            <xsl:attribute name="notBefore" select="$headerInfo//uibk:dating/@notBefore"/>
                        </xsl:if>
                        <xsl:if test="$headerInfo//uibk:dating/@notAfter">
                            <xsl:attribute name="notAfter" select="$headerInfo//uibk:dating/@notAfter"/>
                        </xsl:if>
                        <xsl:if test="$headerInfo//uibk:dating/@parsed">
                            <xsl:attribute name="when" select="$headerInfo//uibk:dating/@parsed"/>
                        </xsl:if>
                        <xsl:value-of select="string($headerInfo//uibk:dating)"/>
                    </date>
                    <xsl:if test="string($headerInfo//uibk:placeName)!=''">
                        <xsl:text>, </xsl:text>
                        <placeName>
                            <xsl:value-of select="$headerInfo//uibk:placeName"/>
                        </placeName>
                    </xsl:if>
                    <xsl:text>.</xsl:text>
                </title>
                <author>
                    <xsl:value-of select="$headerInfo//uibk:sender"/>
                </author>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:fileDesc" mode="RHaddMetadata">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="RHaddMetadata"/>
            <xsl:apply-templates mode="RHaddMetadata"/>
        </xsl:copy>
        <xsl:if test="$headerInfo//uibk:sender!='UNKNOWN'">
            <profileDesc>
                <correspDesc>
                    <correspAction type="sent">
                        <persName>
                            <xsl:value-of select="$headerInfo//uibk:sender"/>
                        </persName>
                        <xsl:if test="$headerInfo//uibk:placeName!=''">
                            <settlement>
                                <xsl:value-of select="$headerInfo//uibk:placeName"/>
                            </settlement>
                        </xsl:if>
                        <xsl:if test="$headerInfo//uibk:dating">
                            <date>
                                <xsl:if test="$headerInfo//uibk:dating/@notBefore">
                                    <xsl:attribute name="notBefore" select="$headerInfo//uibk:dating/@notBefore"/>
                                </xsl:if>
                                <xsl:if test="$headerInfo//uibk:dating/@notAfter">
                                    <xsl:attribute name="notAfter" select="$headerInfo//uibk:dating/@notAfter"/>
                                </xsl:if>
                                <xsl:if test="$headerInfo//uibk:dating/@parsed">
                                    <xsl:attribute name="when" select="$headerInfo//uibk:dating/@parsed"/>
                                </xsl:if>
                                <xsl:value-of select="string($headerInfo//uibk:dating)"/>
                            </date>
                        </xsl:if>
                    </correspAction>
                    <correspAction type="received">
                        <persName>
                            <xsl:value-of select="$headerInfo//uibk:recipient"/>
                        </persName>
                    </correspAction>
                </correspDesc>
            </profileDesc>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>