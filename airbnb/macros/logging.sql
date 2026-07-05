{% macro learn_logging() %}
    {{ log("Hello World!", info=True) }}
{% endmacro %}