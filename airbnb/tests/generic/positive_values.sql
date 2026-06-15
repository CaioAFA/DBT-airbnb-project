-- Two default parameters: the model name and the column
{% test positive_values(model, column_name) %}

-- If this query returns any statement, dbt will raise an error!
SELECT *
FROM {{ model }}
WHERE {{ column_name }} <= 0

{% endtest%}