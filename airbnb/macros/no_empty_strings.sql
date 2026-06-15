{# Testing:
    dbt compile --inline "{{ no_empty_strings(ref('dim_listings_cleansed')) }}"

    or

    dbt show --inline "SELECT * FROM {{ ref('dim_listing_cleansed') }} WHERE {{ no_empty_strings(ref('dim_listings_cleansed')) }}"
#}

{% macro no_empty_strings(model) %}

    {# Getting all columns from the model #}
    {%- for col in adapter.get_columns_in_relation(model) -%}

        {# Checking type of the column #}
        {%- if col.is_string() %}
            {{ col.name }} IS NOT NULL AND {{ col.name }} <> '' AND 
        {%- endif -%}

    {%- endfor %}

    TRUE
{% endmacro %}