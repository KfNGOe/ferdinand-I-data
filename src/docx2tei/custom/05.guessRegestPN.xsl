<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output method="xml" indent="no"/>
    
    <xsl:template match="/" mode="RHguessRegestPN">
        <xsl:apply-templates mode="RHguessRegestPN"/>
    </xsl:template>
    
    <xsl:template match="@*|*|text()" mode="RHguessRegestPN">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="RHguessRegestPN"/>
            <xsl:apply-templates mode="RHguessRegestPN"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*" mode="guessN">
        <xsl:param name="lastNumber"/>
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="*" mode="guessN">
        <xsl:param name="lastNumber"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="guessN">
                <xsl:with-param name="lastNumber" select="$lastNumber"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="guessN">
                <xsl:with-param name="lastNumber" select="$lastNumber"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="guessN">
        <xsl:param name="lastNumber"/>
        <xsl:call-template name="guessNumber">
            <xsl:with-param name="text" select="."/>
            <xsl:with-param name="lastNumber" select="$lastNumber"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="guessNumber">
        <xsl:param name="text"/>
        <xsl:param name="lastNumber"/>
        <xsl:analyze-string select="$text" regex="([0-9]([0-9\s.])*)\.">
            <xsl:matching-substring>
                <xsl:variable name="numberWithDot" select="regex-group(0)"/>
                <xsl:choose>
                    <xsl:when test="matches($numberWithDot,'\d+\.')">
                        <xsl:variable name="number" select="number(regex-group(1))"/>
                        <xsl:choose>
                            <xsl:when test="$number &lt;= $lastNumber">
                                <xsl:element name="seg">
                                    <xsl:attribute name="n" select="$number"/>
                                    <xsl:value-of select="$numberWithDot"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$numberWithDot"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$numberWithDot"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:copy/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='regesta']" mode="RHguessRegestPN">
        <!-- Count para numbers -->
        <xsl:choose>
            <xsl:when test="//tei:div[@type='transcript']//tei:p[@n]">
                <xsl:variable name="lastNumber" select="number(//tei:div[@type='transcript']//tei:p[@n][position()=last()]/@n)"/>
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="guessN">
                        <xsl:with-param name="lastNumber" select="$lastNumber"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates mode="guessN">
                        <xsl:with-param name="lastNumber" select="$lastNumber"/>
                    </xsl:apply-templates>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="RHguessRegestPN"/>
                    <xsl:apply-templates mode="RHguessRegestPN"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
    
</xsl:stylesheet>