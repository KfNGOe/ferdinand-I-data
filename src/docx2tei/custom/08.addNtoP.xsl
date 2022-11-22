<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

    <xsl:output method="xml" indent="no" encoding="UTF-8"/>


    <!-- Try to connect transcription with commentary, do this to regesta, too? -->

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="tei:*|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:div[@type='transcript' or @type='notes']/tei:p">
        <xsl:variable name="origNode" select="."/>
        <xsl:variable name="paragraphText">
            <xsl:choose>
                <xsl:when test="parent::tei:div[@type='notes']">
                    <xsl:value-of select="normalize-space(string())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="onlyNonItalic"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="matches($paragraphText, '^\d+\]')">
                <xsl:analyze-string select="$paragraphText" regex="^(\d+)\]">
                    <xsl:matching-substring>
                        <p>
                            <xsl:attribute name="n" select="regex-group(1)"/>
                            <xsl:apply-templates select="$origNode/@*"/>
                            <xsl:apply-templates select="$origNode/node()"/>
                        </p>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="tei:p" mode="onlyNonItalic">
        <xsl:apply-templates mode="onlyNonItalic"/>
    </xsl:template>

    <xsl:template match="text()" mode="onlyNonItalic">
        <xsl:choose>
            <xsl:when test="ancestor::*[contains(@rend, 'italic')]">
                <!-- Do nothing -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>