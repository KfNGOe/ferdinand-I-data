<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:uibk="http://www.uibk.ac.at/igwee/ns"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei uibk" version="2.0">

    <xsl:output method="xml" indent="no"/>

    <xsl:import href="../date2iso.xsl"/>

    <xsl:variable name="headerInfo">
        <xsl:variable name="letterHeader">
            <xsl:choose>
                <xsl:when test="//tei:div[@type='letter_header']">
                    <xsl:copy-of select="//*[parent::tei:div[@type='letter_header']]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- RH -->
                        <xsl:when test="//tei:body/tei:table[1]">
                            <xsl:copy-of select="//tei:p[1][following-sibling::tei:table[1]]"/>
                            <xsl:copy-of select="//tei:body/tei:table[1]"/>
                        </xsl:when>
                        <!-- RH -->
                        <xsl:otherwise>
                            <xsl:message>var $letterHeader: empty</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
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
            <xsl:variable name="metadataLine2WithoutBrackets" select="replace($metadataLine2, '[\[\]()?]', '')"/><!-- e.g. 1514 Juli 21. Gmunden. -->            
            <xsl:variable name="dates">
                <!-- RH -->
                <xsl:choose>
                    <xsl:when test="ends-with($metadataLine2WithoutBrackets, '.')">
                        <xsl:choose>
                            <xsl:when test="contains($metadataLine2WithoutBrackets,'. ')">
                                <xsl:value-of select="substring-before($metadataLine2WithoutBrackets,'. ')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before($metadataLine2WithoutBrackets,'.')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Date input not valid, "." at the end missing: <xsl:value-of select="$metadataLine2WithoutBrackets"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- RH -->
            </xsl:variable>            
            <uibk:dating>
                <!-- RH -->
                <!-- date to iso 8601 conversion -->
                <!-- https://stackoverflow.com/questions/17079954/convert-date-time-format-in-xslt -->                
                <xsl:choose>
                    <xsl:when test="contains($dates,' – ')"><!-- e.g. 1514 Juli 21 --><!-- e.g. 1525 März 26 – 31 -->
                        <xsl:attribute name="notBefore">
                            <xsl:analyze-string select="$dates" regex="([0-9]+)\s([A-Za-zä]+)\s([0-9]+)\s–\s([0-9]+)">
                                <xsl:matching-substring>
                                    <xsl:call-template name="date2iso">
                                        <xsl:with-param name="date" select="concat(regex-group(1),' ', regex-group(2),' ', regex-group(3))"/>
                                    </xsl:call-template>                                    
                                </xsl:matching-substring>
                            </xsl:analyze-string>                            
                        </xsl:attribute>
                        <xsl:attribute name="notAfter">
                            <xsl:analyze-string select="$dates" regex="([0-9]+)\s([A-Za-zä]+)\s([0-9]+)\s–\s([0-9]+)">
                                <xsl:matching-substring>
                                    <xsl:call-template name="date2iso">
                                        <xsl:with-param name="date" select="concat(regex-group(1),' ', regex-group(2),' ', regex-group(4))"/>
                                    </xsl:call-template>                                    
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="parsed">
                            <xsl:call-template name="date2iso">
                                <xsl:with-param name="date" select="$dates"/><!-- e.g. 1514 Juli 21 -->
                            </xsl:call-template>
                        </xsl:attribute>                        
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:value-of select="$dates"/><!-- e.g. 1514 Juli 21 -->
                <!-- RH -->
            </uibk:dating>
            
            <xsl:variable name="places">
                <xsl:choose>
                    <xsl:when test="ends-with($metadataLine2WithoutBrackets, '.')">
                        <xsl:choose>
                            <xsl:when test="contains($metadataLine2WithoutBrackets,'. ')">
                                <xsl:value-of select="substring-before(substring-after($metadataLine2WithoutBrackets,'. '), '.')"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:message></xsl:message></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Place input not valid, "." at the end missing: <xsl:value-of select="$metadataLine2WithoutBrackets"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>            
            <uibk:placeName>                
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