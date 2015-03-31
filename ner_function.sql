-- DROP FUNCTION findner (text)

CREATE OR REPLACE FUNCTION findner (the_text text)
  RETURNS jsonb AS
$BODY$

    if 're' in SD:
        ner = SD['ner']
        sent_tokenize = SD['sent_tokenize']
        word_tokenize = SD['word_tokenize']
        os = SD['os']
        json = SD['json']
        NER_JAR = SD['NER_JAR']
        NER_CLASSIFIER = SD['NER_CLASSIFIER']
        NERTagger = SD['NERTagger']
    else:
        import json
        
        # Point these toward your download of Stanford NER
        # Need to figure out which is appropriate classifier to use
        NER_JAR = 'stanford-ner.jar'
        NER_CLASSIFIER = '/Users/igow/stanford-ner-2014-10-26/classifiers/english.muc.7class.distsim.crf.ser.gz'

        # Create Stanford NER Tagger
        from nltk.tag.stanford import NERTagger
        SD['NERTagger'] = NERTagger
        ner = NERTagger(NER_CLASSIFIER, NER_JAR)
        SD['ner'] = ner
        
        from nltk.tokenize import sent_tokenize, word_tokenize
        SD['sent_tokenize'] =sent_tokenize
        SD['word_tokenize'] =word_tokenize

        import os
        java_path = "/usr/bin/java"
        os.environ['JAVAHOME'] = java_path
        SD['os'] = os

        SD['json'] = json
        SD['NER_JAR'] = NER_JAR
        SD['NER_CLASSIFIER'] = NER_CLASSIFIER
        
	sentences = sent_tokenize(the_text.decode('utf8'))
	tagged = [(key, val) for s in sentences for val, key in ner.tag(word_tokenize(s))
					if key != "O"]
    
	nerTags = dict()
	for key, val in tagged:
		if key in nerTags.keys():
			nerTags[key].append(val)
		else:
			nerTags[key] = [val]

    return json.dumps(nerTags)


$BODY$ LANGUAGE plpythonu;

WITH test_data AS (
    -- SELECT director_id, fy_end, director_bio
--     FROM board.director
--     LIMIT 3)
    SELECT UNNEST(ARRAY[1,2,3]) AS director_id,
        UNNEST(ARRAY['2001-03-31'::date, '2001-03-31'::date, '2001-03-31'::date]) AS fy_end,
        UNNEST(ARRAY['Ian Gow and Troy Adair worked in 2007.', 'Troy Adair works for HBS.', 'Nastia Zakolyukina works in Chicago.']) AS director_bio)
SELECT director_id, fy_end, findner(director_bio)
FROM test_data
