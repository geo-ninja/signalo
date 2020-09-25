

CREATE TABLE siro_vl.frame_fixing_type
(
  id serial PRIMARY KEY,
  active boolean default true,
  value_en text,
  value_fr text,
  value_de text
);

INSERT INTO siro_vl.frame_fixing_type (id, value_en, value_fr, value_de) VALUES (1, 'unknown', 'inconnu', 'unknown');
INSERT INTO siro_vl.frame_fixing_type (id, value_en, value_fr, value_de) VALUES (2, 'other', 'autre', 'other');
INSERT INTO siro_vl.frame_fixing_type (id, value_en, value_fr, value_de) VALUES (3, 'to be determined', 'à déterminer', 'to be determined');


INSERT INTO siro_vl.frame_fixing_type (id, value_en, value_fr, value_de) VALUES (10, 'for frame with slides', 'pour cadre avec glissières', 'for frame with slides');
INSERT INTO siro_vl.frame_fixing_type (id, value_en, value_fr, value_de) VALUES (11, 'for frame with fixation lateral', 'pour cadre avec fixation latérale', 'for frame with fixation lateral');
INSERT INTO siro_vl.frame_fixing_type (id, value_en, value_fr, value_de) VALUES (12, 'for fixing the frame with Tespa tape', 'pour fixation du cadre avec bande Tespa', 'for fixing the frame with Tespa tape');
INSERT INTO siro_vl.frame_fixing_type (id, value_en, value_fr, value_de) VALUES (13, 'rectangular for mounting on IPE', 'rectangulaire pour fixation sur IPE', 'rectangular for mounting on IPE');

