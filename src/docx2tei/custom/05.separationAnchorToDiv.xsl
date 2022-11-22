<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:uibk="http://igwee.uibk.ac.at/custom/ns"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei uibk" version="2.0">

    <xsl:output method="xml" indent="no"/>

    <xsl:variable name="anchorOkay">
        <xsl:variable name="firstParent" select="(//uibk:anchor)[1]/parent::*"/>
        <xsl:variable name="check">
            <xsl:for-each select="//uibk:anchor">
                <xsl:if test="parent::*!=$firstParent">no</xsl:if>
                <xsl:if test="@subtype='begin'">
                    <xsl:variable name="followingAnchor" select="following::uibk:anchor[1]"/>
                    <xsl:if test="$followingAnchor/@subtype!='end'">no</xsl:if>
                    <xsl:if test="@n != $followingAnchor/@n">no</xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <!--RH start-->
            <!--   <xsl:when test="not(//uibk:anchor)">no</xsl:when> -->
            <!-- RH end-->
            <xsl:when test="contains($check, 'no')">no</xsl:when>
            <xsl:otherwise>yes</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/" mode="RHseparationAnchorToDiv">
        <xsl:apply-templates mode="RHseparationAnchorToDiv"/>
    </xsl:template>

    <xsl:template mode="RHseparationAnchorToDiv" match="@*|tei:*|uibk:*|text()">
        <xsl:copy>
            <xsl:apply-templates mode="RHseparationAnchorToDiv" select="@*"/>
            <xsl:apply-templates mode="RHseparationAnchorToDiv" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|tei:*|uibk:*|text()" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates mode="copy" />
        </xsl:copy>
    </xsl:template>


    <xsl:template mode="RHseparationAnchorToDiv" match="tei:p[not(ancestor::tei:text)]">
        <xsl:copy>
            <xsl:apply-templates mode="RHseparationAnchorToDiv" select="@*"/>
            <xsl:apply-templates mode="RHseparationAnchorToDiv" />
        </xsl:copy>
    </xsl:template>

    <xsl:template mode="RHseparationAnchorToDiv" match="tei:p[ancestor::tei:text]|tei:table[ancestor::tei:text]">
        <xsl:choose>
            <xsl:when test="$anchorOkay='yes'">
                <!-- do nothing -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates mode="RHseparationAnchorToDiv" select="@*"/>
                    <xsl:apply-templates mode="RHseparationAnchorToDiv" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="copyFirstParagraphs">
        <xsl:variable name="firstAnchor" select="(//uibk:anchor)[1]"/>
        <xsl:for-each select="$firstAnchor/preceding-sibling::*">
            <xsl:copy>
                <xsl:apply-templates mode="RHseparationAnchorToDiv" select="@*"/>
                <xsl:apply-templates mode="RHseparationAnchorToDiv" />
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="copyLastParagraphs">
        <xsl:variable name="lastAnchor" select="//uibk:anchor[not(following::uibk:anchor)]"/>
        <xsl:for-each select="$lastAnchor/following-sibling::*">
            <xsl:copy>
                <xsl:apply-templates select="@*" mode="copy"/>
                <xsl:apply-templates mode="copy"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="copyBetweenAnchor">
        <xsl:param name="beginAnchor"/>
        <xsl:param name="endAnchor"/>
        <xsl:variable name="parentNode" select="$beginAnchor/parent::*"/>
        <xsl:variable name="beginPosition" select="count($beginAnchor/preceding-sibling::*) + 1 "/>
        <xsl:variable name="endPosition" select="count($endAnchor/preceding-sibling::*) + 1" />
        <xsl:for-each select="$parentNode/*[position() &gt; $beginPosition and position() &lt; $endPosition]">
            <xsl:copy>
                <xsl:apply-templates select="@*" mode="copy"/>
                <xsl:apply-templates mode="copy" />
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>

    <xsl:template mode="RHseparationAnchorToDiv" match="uibk:anchor">

        <xsl:choose>
            <xsl:when test="$anchorOkay='yes'">
                <xsl:if test="not(preceding-sibling::uibk:anchor)">
                    <!-- first anchor -->
                    <div type="letter_header">
                        <xsl:call-template name="copyFirstParagraphs"/>
                    </div>
                </xsl:if>
                <xsl:variable name="followingAnchor" select="following-sibling::uibk:anchor[1]"/>
                <xsl:choose>
                    <xsl:when test="@n = $followingAnchor/@n">
                        <div>
                            <xsl:attribute name="type" select="@n"/>
                            <xsl:call-template name="copyBetweenAnchor">
                                <xsl:with-param name="beginAnchor" select="."/>
                                <xsl:with-param name="endAnchor" select="$followingAnchor"/>
                            </xsl:call-template>
                        </div>
                    </xsl:when>
                    <xsl:when test="not($followingAnchor)">
                        <!-- do nothing -->
                    </xsl:when>
                    <xsl:otherwise>
                        <div type="transcription">
                            <xsl:call-template name="copyBetweenAnchor">
                                <xsl:with-param name="beginAnchor" select="."/>
                                <xsl:with-param name="endAnchor" select="$followingAnchor"/>
                            </xsl:call-template>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="not($followingAnchor)">
                    <!-- last anchor -->
                    <div>
                        <xsl:call-template name="copyLastParagraphs"/>
                    </div>
                </xsl:if>

            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates mode="RHseparationAnchorToDiv" select="@*"/>
                    <xsl:apply-templates mode="RHseparationAnchorToDiv" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>