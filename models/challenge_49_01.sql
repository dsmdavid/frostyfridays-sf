{{
  config(
    materialized = 'view',
    )
}}

SELECT parse_xml('<?xml version="1.0" encoding="UTF-8"?>
<library>
    <book>
        <title>The Great Gatsby</title>
        <author>F. Scott Fitzgerald</author>
        <year>1925</year>
        <publisher>Scribner</publisher>
    </book>
    <book>
        <title>To Kill a Mockingbird</title>
        <author>Harper Lee</author>
        <year>1960</year>
        <publisher>J. B. Lippincott & Co.</publisher>
    </book>
    <book>
        <title>1984</title>
        <author>George Orwell</author>
        <year>1949</year>
        <publisher>Secker & Warburg</publisher>
    </book>
</library>
') AS xml_content
