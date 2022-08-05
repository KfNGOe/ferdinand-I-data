<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:uibk="http://igwee.uibk.ac.at/custom/ns"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

    <xsl:output method="xml" indent="no"/>

    <xsl:template match="@*|tei:*|text()" mode="RHinsertSeparationAnchor">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>

    <!--    <xsl:template match="tei:p[@rend]">
        <xsl:choose>
            <xsl:when test="@rend='regest_de'">
                <xsl:variable name="firstRegestDe" select="//tei:p[@rend='regest_de' and not(preceding::tei:p[@rend='regest_de'])]"/>
                <xsl:variable name="lastRegestDe" select="//tei:p[@rend='regest_de' and not(following::tei:p[@rend='regest_de'])]"/>
                <xsl:if test="not(//tei:p[preceding::tei:p=$firstRegestDe and following::tei:p=$lastRegestDe and not(@rend='regest_de')])">
                    
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
-->

    <xsl:template match="tei:p[@rend]">
        <xsl:choose>
            <xsl:when test="@rend='italic'">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="rendKey" select="@rend"/>
                <xsl:choose>
                    <xsl:when test="contains($rendKey, 'Regest') or contains($rendKey, 'Kommen') or contains($rendKey, 'Archiv')">
                        <xsl:if test="not(preceding::tei:p[@rend = $rendKey])">
                            <uibk:anchor>
                                <xsl:attribute name="type">separator</xsl:attribute>
                                <xsl:attribute name="subtype">begin</xsl:attribute>
                                <xsl:attribute name="n" select="$rendKey"/>
                            </uibk:anchor>
                        </xsl:if>
                        <xsl:copy>
                            <xsl:apply-templates select="@*"/>
                            <xsl:apply-templates/>
                        </xsl:copy>
                        <xsl:if test="not(following::tei:p[@rend = $rendKey])">
                            <uibk:anchor>
                                <xsl:attribute name="type">separator</xsl:attribute>
                                <xsl:attribute name="subtype">end</xsl:attribute>
                                <xsl:attribute name="n" select="$rendKey"/>
                            </uibk:anchor>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*"/>
                            <xsl:apply-templates />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>