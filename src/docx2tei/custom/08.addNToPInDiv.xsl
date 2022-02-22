<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="no"/>
    
    <xsl:variable name="numberPattern">^\d+.*</xsl:variable>
    
    <xsl:template match="@* | tei:* | text()">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='commentary' or @type='transcription']/tei:p">
        <xsl:choose>
            <xsl:when test="matches(string(.), $numberPattern)">
                <xsl:variable name="pNumber">
                    <xsl:analyze-string select="string(.)" regex="^(\d+)[\].)]">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="n" select="$pNumber"/>
                    <xsl:apply-templates />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>