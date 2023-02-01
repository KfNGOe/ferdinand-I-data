<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"    
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">
    
    <xsl:template match="/" name="date2iso">    

        <xsl:param name="date"/><!-- e.g. 1514 Juli 21 -->
        
        <!-- iso 8601: YYYY-MM-DD -->
        
        <xsl:analyze-string select="$date" regex="([0-9]+)\s([A-Za-zä]+)\s([0-9]+)">

            <xsl:matching-substring>
                <xsl:variable name="year" select="regex-group(1)"/>
                <xsl:variable name="month" select="regex-group(2)"/>
                <xsl:variable name="day" select="regex-group(3)"/>                
                
                <xsl:variable name="reformattedYear" select="$year"/>
                <xsl:variable name="reformattedMonth">
                    <xsl:choose>
                        <xsl:when test="$month = 'Jänner'">01</xsl:when>
                        <xsl:when test="$month = 'Februar'">02</xsl:when>
                        <xsl:when test="$month = 'März'">03</xsl:when>
                        <xsl:when test="$month = 'April'">04</xsl:when>
                        <xsl:when test="$month = 'Mai'">05</xsl:when>
                        <xsl:when test="$month = 'Juni'">06</xsl:when>
                        <xsl:when test="$month = 'Juli'">07</xsl:when>
                        <xsl:when test="$month = 'August'">08</xsl:when>
                        <xsl:when test="$month = 'September'">09</xsl:when>
                        <xsl:when test="$month = 'Oktober'">10</xsl:when>
                        <xsl:when test="$month = 'November'">11</xsl:when>
                        <xsl:when test="$month = 'Dezember'">12</xsl:when>
                    </xsl:choose>    
                </xsl:variable>
                <xsl:variable name="reformattedDay">
                    <xsl:if test="(string-length($day) &lt; 2)">
                        <xsl:value-of select="0"/>
                    </xsl:if>
                    <xsl:value-of select="$day"/>    
                </xsl:variable>
                
                <xsl:variable name="reformattedDate" select="concat($reformattedYear, '-', $reformattedMonth, '-', $reformattedDay)" />
                <xsl:value-of select="$reformattedDate"/>
                
            </xsl:matching-substring>
        </xsl:analyze-string>
        
    </xsl:template>

</xsl:stylesheet>
