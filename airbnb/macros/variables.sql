{#
    To execute this:
    dbt run-operation learn_variables --vars '{user_name: CAFArrabal}'
#}

{% macro learn_variables() %}

    {# Jinja variable #}
    {% set your_name_jinja = "Caio" %}
    {{ log("Hello " ~ your_name_jinja, info=True) }}

    {# dbt variable with default value #}
    {{ log("Hello dbt user " ~ var("user_name", "NO USERNAME IS SET") ~ "!", info=True) }}

{% endmacro %}