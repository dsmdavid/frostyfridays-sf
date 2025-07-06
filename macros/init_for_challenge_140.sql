{% macro init_challenge_140() %}
  {{ log('Starting challenge_140 pre-work', info=True)}}
  {% set initial_query %}
USE WAREHOUSE {{ target.warehouse }};
USE DATABASE {{ target.database }};
USE SCHEMA {{ target.schema }};

-- Run the statements below to create the required tables and sample rows:

-- Create invoice_line_items table
CREATE OR REPLACE TABLE ch140_invoice_line_items (
    line_item_id INTEGER,
    service_description STRING
);

-- Create service_categories table
CREATE OR REPLACE TABLE ch140_service_categories (
    category_id INTEGER,
    category_name STRING
);

-- Insert sample invoice line items
INSERT INTO ch140_invoice_line_items (line_item_id, service_description) VALUES
(1, 'Deployment of Snowflake project - Phase 1'),
(2, 'Data ingestion pipeline optimization'),
(3, 'Security and access review for Snowflake'),
(4, 'Ongoing data modeling support'),
(5, 'Snowflake training session for analysts');

-- Insert sample categories
INSERT INTO ch140_service_categories (category_id, category_name) VALUES
(1, 'Snowflake Deployment'),
(2, 'Data Engineering'),
(3, 'Security Review'),
(4, 'Training'),
(5, 'Analytics Support');


  {% endset %}
  {{ log('Query for challenge_140 created', info=True)}}

{% do run_query(initial_query) %}
  {{ log('Query for challenge_140 ran', info=True)}}


{% endmacro %}