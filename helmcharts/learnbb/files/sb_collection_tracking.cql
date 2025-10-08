-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS sb_collection_tracking
WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};


CREATE TABLE IF NOT EXISTS sb_collection_tracking.batches (
    activityid text,
    activitytype text,
    batchid text,
    cert_templates map<text, frozen<map<text, text>>>,
    created_date timestamp,
    createdby text,
    createdfor list<text>,
    description text,
    end_date timestamp,
    enrollment_enddate timestamp,
    enrollmenttype text,
    name text,
    start_date timestamp,
    status int,
    updated_date timestamp,
    PRIMARY KEY (activityid, batchid)
) WITH CLUSTERING ORDER BY (batchid ASC);

-- User enrolments table
CREATE TABLE IF NOT EXISTS sb_collection_tracking.user_enrolments (
    userid text,
    activityid text,
    activitytype text,
    batchid text,
    active boolean,
    addedby text,
    completedon timestamp,
    statusmap map<text, int>,
    datetime timestamp,
    enrolled_date timestamp,
    issued_certificates list<frozen<map<text, text>>>,
    progress int,
    status int,
    PRIMARY KEY (userid, activityid, activitytype, batchid)
) WITH CLUSTERING ORDER BY (activityid ASC, activitytype ASC, batchid ASC);