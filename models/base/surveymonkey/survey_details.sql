with

survey_details as (
  select * from stitch_import_api.survey_details
), 

headings as (
  select * from stitch_import_api.survey_details__pages__questions__headings
),

pages as (
  select * from stitch_import_api.survey_details__pages
)

, questions as (
  select * from stitch_import_api.responses__pages__questions
)

, survey_details_questions as (
  select * from stitch_import_api.survey_details__pages__questions
)

, responses as (
  select * from stitch_import_api.responses
)

, answers as (
  select * from stitch_import_api.responses__pages__questions__answers
)

, choices as (
  select * from stitch_import_api.survey_details__pages__questions__answers__choices
)



-- select 
--   sd.id as survey_id, 
--   sd.title,
--   sd.question_count,
--   sd.response_count,
--   h.heading,
--   p.title as page_title,
--   q.id as question_id,
--   r.response_status,
--   a.text as answer_text,
--   c.text as choice_text,
--   c.id as choice_id
-- from
-- headings h
-- left join survey_details sd on sd.id = h._sdc_source_key_id
-- left join pages p on p._sdc_source_key_id = h._sdc_source_key_id
-- left join responses r on r.survey_id = h._sdc_source_key_id
-- left join questions q on q._sdc_source_key_id = r.id
-- left join answers a on a._sdc_source_key_id = r.id 
-- left join choices c on c.id = a.choice_id

, responses2 as (
select
  sd.id as survey_id,
  a.text as answer_text,
  r.id as response_id
from survey_details sd
join responses r on r.survey_id = sd.id
join answers a on a._sdc_source_key_id = r.id
),



answers2 as (
  select
  a.choice_id as answer_choice_id,
  a._sdc_source_key_id as source_key_id,
  a._sdc_level_0_id,
  a._sdc_level_1_id,
  c.text as choice_text,
  a.text as answer_text
  from answers a
  -- LEFT JOIN TO GET ANSWER TEXT WHEN THERE IS NO CHOICE_ID (I.E. FREE TEXT ENTRY)
  left join choices c on c.id = a.choice_id
)

, questions2 as (
  select
  q.id as question_id,
  q._sdc_source_key_id as response_id,
  a2.answer_choice_id as choice_id,
  a2.choice_text,
  a2.answer_text
  from questions q
  join responses r on q._sdc_source_key_id = r.id
  -- LEFT JOIN NOT NECESSARY (?)
  left join answers2 a2 on a2.source_key_id = r.id and a2._sdc_level_0_id = q._sdc_level_0_id and a2._sdc_level_1_id = q._sdc_level_1_id
  --join answers a2 on a2._sdc_source_key_id = q._sdc_source_key_id
),


-- select
--   r2.survey_id,
--   r2.answer_text,
--   r2.response_id,
--   q2.question_id
-- from questions2 q2
-- join responses2 r2 on r2.response_id = q2.response_id and = q2.question_id


foo as (select
  q2.question_id,
  q2.response_id,
  q2.choice_id,
  q2.choice_text,
  q2.answer_text
  --a2.answer_choice_id
from questions2 q2
join survey_details_questions sdq on sdq.id = q2.question_id)
-- join answers a2 on a2._sdc_source_key_id = q2.response_id

select foo.question_id, foo.response_id, foo.choice_id, foo.choice_text, foo.answer_text
from foo
--join foo on foo.response_id = a2._sdc_source_key_id
