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

, responses as (
  select * from stitch_import_api.responses
)

, answers as (
  select * from stitch_import_api.responses__pages__questions__answers
)

, choices as (
  select * from stitch_import_api.survey_details__pages__questions__answers__choices
)

select 
  sd.id as survey_id, 
  sd.title,
  sd.question_count,
  sd.response_count,
  h.heading,
  p.title as page_title,
  q.id as question_id,
  r.response_status,
  a.text as answer_text,
  c.text as choice_text,
  c.id as choice_id
from
headings h
left join survey_details sd on sd.id = h._sdc_source_key_id
left join pages p on p._sdc_source_key_id = h._sdc_source_key_id
left join responses r on r.survey_id = h._sdc_source_key_id
left join questions q on q._sdc_source_key_id = r.id
left join answers a on a._sdc_source_key_id = r.id 
left join choices c on c.id = a.choice_id
