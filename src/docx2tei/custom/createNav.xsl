<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" omit-xml-declaration="yes" encoding="ISO-8859-1"/>
    
    <xsl:template match="/">
        <nav>
            <ul class="nav nav-pills">
                <xsl:for-each select="//filename">
                    <xsl:variable name="name" select="."/>
                    <li><a href="#letterTop" onclick="loadLetter('laferl/{$name}.html', this.parentNode)"><xsl:value-of select="$name"/></a></li>
                </xsl:for-each>
            </ul>
        </nav>
    </xsl:template>
    
</xsl:stylesheet>