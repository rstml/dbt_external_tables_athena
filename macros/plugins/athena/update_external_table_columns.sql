{% macro athena__update_external_table_columns(source_node) %}

    {% set lf_tags_config = source_node.external.get('lf_tags_config') %}
    {% set target_relation = source(source_node.schema, source_node.name) %}

    {% if lf_tags_config is not none %}
        {% do adapter.add_lf_tags(target_relation, lf_tags_config) %}
    {% endif %}

{% endmacro %}