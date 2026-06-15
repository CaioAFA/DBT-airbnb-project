-- When testing a model, we have one default parameter:
-- Model
-- But you can add as many parameters you want
{% test minimum_row_count(model, min_row_count) %}

-- You can generalize the severity directly on the test
-- {{ config(severity = 'warn') }}

SELECT
    COUNT(*) as cnt
FROM
    {{ model }}
HAVING
    COUNT(*) < {{ min_row_count }}
{% endtest %}