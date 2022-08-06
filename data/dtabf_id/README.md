### dtabf2dtabf_id conversion by xslt

2 steps:

1.  make register from dtabf files with:<br>
    ..\github\ferdinand-I-data\src\dtabf2dtabf_id\test_register_make_person.xsl
    ..\github\ferdinand-I-data\src\dtabf2dtabf_id\test_register_make_place.xsl
    ..\github\ferdinand-I-data\src\dtabf2dtabf_id\test_register_make_index.xsl

2.  copy id from register to letters with:<br>
    ..\github\ferdinand-I-data\src\dtabf2dtabf_id\test_letters_copy_id.xsl
