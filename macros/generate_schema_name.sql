{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set target_name = target.name | lower -%}

    {%- if target_name == 'prod' or target_name == 'production' -%}

        prod_{{ custom_schema_name | trim }}

    {%- else -%}

        {{ target.schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}