
declare namespace teins = "http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";
declare function functx:distinct-element-names
  ( $nodes as node()* )  as xs:string* {

   (: distinct-values($nodes/descendant-or-self::*/name(.)) :)  
   (: distinct-values($nodes[contains(.,"szdg")] ) :)
   (:  distinct-values($nodes) :)
   distinct-values($nodes/@*/name(.))
 } ;

let $in-xml := ./TEI//p
(: let $in-xml := ./TEI :)
(:let $in-xml := (collection ("file:/C:/Users/rh/GitHub-privat/KNGÖ/Migration/ferdinand/data/Band 1/xml")//TEI ) :)
(: let $in-xml := (doc ("file:/C:/Users/rh/Git-PLUS/SZD/data/Library/tei/SZDBIB.xml")//biblFull//titleStmt/title/@type ) :)


return
 functx:distinct-element-names($in-xml)


(:
//biblFull//provenance//attribute()[ contains(.,"de") and ( not( contains(.,"LaterOwner") ) ) ]
:)