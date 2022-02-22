<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="no"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@*|*|text()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*|*" mode="invertItalic">
        <xsl:copy>
            <xsl:apply-templates mode="invertItalic"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:hi[contains(@rend,'italic')]" mode="invertItalic">
        <xsl:choose>
            <xsl:when test="@rend='italic'">
                <xsl:choose>
                    <xsl:when test="@*[name()!='rend']">
                        <hi>
                            <xsl:apply-templates select="@*[not(name()='rend')]" mode="invertItalic"/>
                            <xsl:apply-templates/>
                        </hi>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <hi>
                    <xsl:attribute name="rend" select="normalize-space(replace(@rend, 'italic', ' '))"></xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='rend')]" mode="invertItalic"/>
                    <xsl:apply-templates />
                </hi>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" mode="invertItalic">
        <hi>
            <xsl:attribute name="rend">italic</xsl:attribute>
            <xsl:copy></xsl:copy>
        </hi>
    </xsl:template>
        

    <xsl:template match="tei:p[ancestor::tei:div[@type='Kommentar'] and not(./ancestor::tei:note) and not(./attribute::rend)]">
        <xsl:copy>
            <xsl:attribute name="rend">Kommentar</xsl:attribute>
            <xsl:apply-templates select="@*[name()!='rend']"/>
            <xsl:apply-templates mode="invertItalic"/>
        </xsl:copy>
    </xsl:template>
        
</xsl:stylesheet>