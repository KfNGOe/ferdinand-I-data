<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:uibk="http://igwee.uibk.ac.at/custom/ns"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="no" />
    
    <xsl:template match="@*|tei:*|uibk:*|text()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="uibk:anchor">
        <xsl:choose>
            <xsl:when test="@subtype='begin'">
                <xsl:choose>
                    <xsl:when test="contains(@n, 'Englisch')">
                        <uibk:anchor type="separator" subtype="end" n="Regest Deutsch" />
                    </xsl:when>
                    <xsl:when test="contains(@n, 'Archiv')">
                        <uibk:anchor type="separator" subtype="end" n="Regest Englisch"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="@subtype='end' and contains(@n, 'Archiv')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <!-- do nothing? -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
            <uibk:anchor type="separator" subtype="end" n="Kommentar"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>