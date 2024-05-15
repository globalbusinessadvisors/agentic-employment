-- Create the table for storing documentation
CREATE TABLE documentation (
    id SERIAL PRIMARY KEY,
    tenant_id UUID NOT NULL,
    doc_type VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial documentation data
INSERT INTO documentation (tenant_id, doc_type, title, content) VALUES
('tenant-1-uuid', 'User Guide', 'Getting Started with Agents', 'This guide will help you get started with setting up and managing agents.'),
('tenant-1-uuid', 'API Reference', 'Agent API Endpoints', 'This document provides details on the API endpoints available for agent management.'),
('tenant-2-uuid', 'User Guide', 'Advanced Agent Configuration', 'This guide covers advanced configuration options for agents.'),
('tenant-2-uuid', 'Compliance', 'Data Privacy Policies', 'This document outlines the data privacy policies applicable to agents.');

-- Enable Row-Level Security (RLS) for the documentation table
ALTER TABLE documentation ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for documentation
CREATE POLICY "tenant_isolation" ON documentation
FOR ALL
USING (tenant_id = current_setting('app.current_tenant')::uuid);

CREATE POLICY "Enable real-time" ON documentation
FOR SELECT USING (true);

CREATE POLICY "documentation_access" ON documentation
FOR SELECT
USING (auth.uid() = user_id);

-- Create indexes for optimization
CREATE INDEX idx_documentation_tenant_id ON documentation(tenant_id);