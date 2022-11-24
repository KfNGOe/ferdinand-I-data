xquery version "3.1";
declare default element namespace "http://www.tei-c.org/ns/1.0";
(:declare namespace teins = "http://www.tei-c.org/ns/1.0";:)
declare namespace functx = "http://www.functx.com";
declare namespace uibk = "http://igwee.uibk.ac.at/custom/ns" ;

declare function local:insert-element($nodes as node()*)
{
 for $node in $nodes
 return 
    typeswitch($node)
        case element(author)
            return 
                element { name($node) } {
                    $node/@*, 
                    (:local:insert-element($node/element()), :)
                    element persName { attribute ref { "nognd" }, $node/text() }                     
                }
        case element(title)
            return 
                element { name($node) } {
                    $node/@*,
                    if ($node/@type = "sub") 
                    then (
                        $node/persName[1]/text(),
                        $node/persName[1]/following-sibling::text()[1],                    
                        $node/persName[2]/text(),
                        $node/persName[2]/following-sibling::text()[1],                    
                        $node/date/text(),
                        $node/date/following-sibling::text()[1],
                        $node/placeName/text(),
                        $node/placeName/following-sibling::text()[1]                        
                    )
                    else ($node/text())
                }
        case element(persName)
            return 
                element { name($node) } {
                    attribute ref { "nognd" },
                    (:if (($node[parent::title]) and ($node[@role])) then () else ($node/@*),:)
                    $node/@*,
                    local:insert-element($node/node())
                }
        case element(editionStmt)
            return
                <editionStmt>
                    <edition>Vollständige digitalisierte Ausgabe</edition>
                </editionStmt>
            
        case element(publicationStmt)
            return
                <publicationStmt>
                    <publisher xml:id="nnnn">
                       <orgName role="hostingInstitution">Universität Salzburg</orgName>
                       <orgName role="project">Edition der Familienkorrespondenz Ferdinands I.</orgName>               
                       <address>
                        <addrLine>Paris Lodron Universität Salzburg PLUS</addrLine>
                        <addrLine>Kapitelgasse 4</addrLine>
                        <addrLine>A-5020 Salzburg - Österreich</addrLine>                  
                       </address>
                    </publisher>                    
                    <pubPlace>Salzburg</pubPlace>
                    <date type="publication">2015-07-09</date>
                    <availability>
                       <licence target="https://creativecommons.org/licenses/by/3.0/">
                          <p>Creative Commons BY 3.0</p>
                       </licence>
                    </availability>
                    <idno type="DOI">nnnn</idno>
            </publicationStmt>
            
        case element(sourceDesc)
            return
                <sourceDesc>
                    <bibl type="MS">Ferdinand I., Kaiser: Die Korrespondenz Ferdinands I. Familienkorrespondenz bis 1526. Bd. 1. Wien, 1912.</bibl>
                    <biblFull>
                       <titleStmt>
                          <title level="m" type="main">Die Korrespondenz Ferdinands I.</title>
                          <title level="m" type="volume" n="1">1</title>
                          <title type="part" n="11">Familienkorrespondenz bis 1526 / bearb. von Wilhelm Bauer</title>
                          <author>
                             <persName>Ferdinand I., Heiliges Römisches Reich, Kaiser, 1503-1564</persName>
                          </author>
                       </titleStmt>               
                       <publicationStmt>
                          <publisher>
                             <name>Holzhausen</name>
                          </publisher>
                          <publisher>
                             <name>Kommission für Neuere Geschichte Österreichs</name>
                          </publisher>
                          <pubPlace>Wien</pubPlace>
                          <date type="publication">1912</date>
                       </publicationStmt>               
                    </biblFull>
                 </sourceDesc>
                              
        case element(placeName)
            return 
                element { name($node) } {
                    attribute ref { "nognd" },
                    $node/@*, 
                    local:insert-element($node/node())
                }
        case element(settlement)
            return 
                element placeName { 
                attribute ref { "nognd" }, 
                $node/text() 
                }
        case element(name)
            return 
                element { name($node) } {
                    attribute ref { "nognd" },
                    $node/@*,
                    $node/text()
                    (:local:insert-element($node/node()) :)
                }
        case element(hi)
            return
            if (
                $node/@rend = "normalweight" or
                $node/@rend = "color(FF0000)" or
                $node/@rend = "background(red)" or
                $node/@rend = "background(green)" or
                $node/@rend = "background(yellow)"
            ) 
            then (                
                local:insert-element($node/node())
            )            
            else (
                element { name($node) } {
                    $node/@*[not(name()="rend")],
                    attribute rendition { 
                        if ($node/@rend ="bold") then ("#b") else (), 
                        if ($node/@rend ="italic") then ("#i") else (),
                        if ($node/@rend ="superscript") then ("#sup") else (),
                        if ($node/@rend ="italic superscript") then ("#i #sup") else (),
                        if ($node/@rend ="italic normalweight") then ("#i") else (),
                        if ($node/@rend ="italic spaced") then ("#i") else (),
                        if ($node/@rend ="italic color(FF0000)") then ("#i") else (),                        
                        if ($node/@rend ="superscript color(FF0000)") then ("#sup") else (),
                        if ($node/@rend ="italic color(7030A0)") then ("#i") else (),
                        if ($node/@rend ="capsall") then ("#k") else (),
                        if ($node/@rend ="spaced") then ("#g") else ()                        
                    },                                        
                    local:insert-element($node/node())
                }
            )                      
        case element(div)
            return
                element { name($node) } {
                    $node/@*[not(name()="type")],
                    if ($node/@type ="letter_header") 
                    then (
                        attribute n {"1"},
                        comment{" letter_header "}
                    )                    
                    else (
                        if ($node/@type = "regest_de") 
                        then (
                            attribute n {"2"},
                            attribute xml:lang {"de"},
                            comment{" regest_de "}
                        )                        
                        else (
                            if ($node/@type = "regest_en")
                            then (
                                attribute n {"3"},
                                attribute xml:lang {"en"},
                                comment{" regest_en "}
                            )                             
                            else (
                                if ($node/@type ="archive_desc") 
                                then (                                            
                                    attribute n {"4"},
                                    comment{" archive_desc "}
                                )                                 
                                else (
                                    if ($node/@type ="transcription") 
                                    then (
                                        attribute type {"letter"},
                                        attribute n {"5"},
                                        comment{" transcription "}
                                    )
                                    else (
                                        if ($node/@type ="commentary") 
                                        then (                                            
                                            attribute n {"6"},
                                            comment{" commentary "}
                                        )
                                        else()
                                    )
                                )
                            )                                                            
                        )
                    ),
                    local:insert-element($node/node())
                }
        case element(p)
            return
                element { name($node) } {
                    $node/@*,
                    local:insert-element($node/node())
                }
        case element(index)
            return
                <index resp="{$node/@resp}">
                    <term key="{$node/@key}">
                    {                        
                        local:insert-element($node/node())
                    }
                    </term>
                </index>
        case element(seg)
            return
            $node/text()
        case element(anchor)
            return 
                local:insert-element($node/node())
        case element()
            return 
                element { name($node) } {
                    $node/@*, 
                    local:insert-element($node/node())
                }
        default 
            return $node
};

(: (doc ("file:/C:/Users/rh/Git-PLUS/SZD/data/Library/tei/SZDBIB.xml")//biblFull//titleStmt/title/@type ) :)


(:let $doc := (doc ("file:/C:/Users/rh/GitHub-privat/KNG%C3%96/Migration/ferdinand/data/Band%201/xml/A003.xml")/TEI):)
(:let $collection  := (coll ("file:/C:/Users/rh/GitHub-privat/KNG%C3%96/Migration/ferdinand/data/Band%201/xml/input-tei")) :)
let $doc := ./TEI 
return 
local:insert-element($doc)

(:for $node in ./TEI 
return
$node//titleStmt :)
 