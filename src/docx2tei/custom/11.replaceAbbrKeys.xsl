<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"    
    xmlns:functx="http://www.functx.com"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="no" />
    
    <xsl:variable name="xlsx2tei" select="document('../../../data/tei/Ferdinand_Register_Personen_abgekuerzte_Namen.xml')"/>
	    
    <xsl:function name="functx:replace-key" as="node()*"
        xmlns:functx="http://www.functx.com"
        xmlns:tei="http://www.tei-c.org/ns/1.0">
        <xsl:param name="elements" as="node()"/> <!-- var xlsx2tei_ -->        
        <xsl:param name="key" as="item()"/> <!-- var @key -->
                
        <xsl:for-each select="$elements//tei:cell[1]">            
            <xsl:variable name="key_old" select="normalize-space(.)"/>            
            <xsl:if test="$key_old = $key">                
                <xsl:value-of select="normalize-space(../tei:cell[2])"/>    
            </xsl:if>   
        </xsl:for-each>
    </xsl:function>
    
    <xsl:template match="@*|*|text()" mode="RHreplaceAbbrKeys">    
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="RHreplaceAbbrKeys"/>
            <xsl:apply-templates mode="RHreplaceAbbrKeys"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:persName/@key" mode="RHreplaceAbbrKeys">
        <xsl:variable name="info" select="functx:replace-key($xlsx2tei, .)"/>
        <xsl:choose>
            <xsl:when test="not(exists($info))">            
                <xsl:copy/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="key" select="$info"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
       
</xsl:stylesheet>