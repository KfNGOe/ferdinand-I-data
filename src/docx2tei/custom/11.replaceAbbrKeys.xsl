<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uibk="http://www.uibk.ac.at/igwee/ns"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="no" />
    
    <xsl:template match="@*|*|text()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:persName/@key">
        <xsl:variable name="info" select="uibk:fetchterm(normalize-space(.))"/>
        <xsl:choose>
            <xsl:when test="$info=''">
                <xsl:copy/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="key" select="$info"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>