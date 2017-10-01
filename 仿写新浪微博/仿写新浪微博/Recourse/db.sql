CREATE TABLE IF NOT EXISTS "T_Status" (
    "statusId" integer NOT NULL,
    "status" text,
    "userId" integer,
    "createTime" text DEFAULT (datetime('now', 'localtime')),
    PRIMARY KEY ("statusId")
);
