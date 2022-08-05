# fn:collection problem

## solution:

1. for the collection, there is a separate file that contains a list of the xml documents:
   
ex: test.xml

```
<collection stable="true">    
    <doc href="A001.xml"/>
    <doc href="A002.xml"/>
    <doc href="A003.xml"/>
</collection>
```

!!!
the collection file must be in the same dir as the documents !!!!

2. the xslt stylesheet refers to the collection in this way:

ex: test_arche.xsl

```
<xsl:variable name="doc_coll" select="doc('../data/dtabf/band_001/test.xml')"/>
```
this variable doc_coll is then iterated on and the individual documents are opened with fn:doc:

```
<xsl:for-each select="$doc_coll//doc/@href">
                <xsl:variable name="doc_file" select="doc(.)"/>
                
                <acdh:hasTitle xml:lang="en"><xsl:value-of select="$doc_file//tei:title[@type='main'][1]/text()"/></acdh:hasTitle>
```
as an example in line 58 the title of the letter is selected.

!!!
line 56 has error: doc(.) refers to the xslt-path, must be changed to the path of the collection-file. 
!!!

!!!
test bsp.e can be found at \github\dev-ferdinand-I-app in the branch rh-static-search-test.
!!!
