-- SAK-46436 START
CREATE TABLE TASKS_ASSIGNED
(
    ID               BIGINT AUTO_INCREMENT NOT NULL,
    OBJECT_ID        VARCHAR(99)           NULL,
    ASSIGNATION_TYPE VARCHAR(255)          NOT NULL,
    TASK_ID          BIGINT                NOT NULL,
    CONSTRAINT PK_TASKS_ASSIGNED PRIMARY KEY (ID)
);

ALTER TABLE TASKS ADD TASK_OWNER VARCHAR(99) NULL;
CREATE INDEX IDX_TASKS_ASSIGNED ON TASKS_ASSIGNED (TASK_ID);
ALTER TABLE TASKS_ASSIGNED
    ADD CONSTRAINT FK915ilfdtgcwqab3xuyfwn95ao FOREIGN KEY (TASK_ID) REFERENCES TASKS (ID) ON UPDATE RESTRICT ON DELETE RESTRICT;
-- SAK-46436 END

-- SAK-46986 START
CREATE TABLE TASK_GROUPS
(
    TASK_ID  BIGINT      NOT NULL,
    GROUP_ID VARCHAR(99) NULL
);

CREATE INDEX FK7x7ajup3bwe3hcwq057evmala ON TASK_GROUPS (TASK_ID);
ALTER TABLE TASK_GROUPS
    ADD CONSTRAINT FK7x7ajup3bwe3hcwq057evmala FOREIGN KEY (TASK_ID) REFERENCES TASKS (ID) ON UPDATE RESTRICT ON DELETE RESTRICT;
-- SAK-46986 END

-- SAK-46178 START
ALTER TABLE rbc_rating ADD order_index INT DEFAULT null NULL;
ALTER TABLE rbc_criterion ADD order_index INT DEFAULT null NULL;
ALTER TABLE rbc_tool_item_rbc_assoc ADD siteId VARCHAR(99) NULL;
ALTER TABLE rbc_tool_item_rbc_assoc ADD CONSTRAINT rbc_item_rubric UNIQUE (itemId, rubric_id);
ALTER TABLE rbc_criterion_ratings DROP FOREIGN KEY FK2ecdorwm3nm2ytyg9uvxlik53;
ALTER TABLE rbc_criterion_ratings DROP FOREIGN KEY FKd03estm381c26jhsq4wd44vwx;
ALTER TABLE rbc_evaluation DROP FOREIGN KEY FKem9md18gcni93xqa5ijykty8e;
ALTER TABLE rbc_rubric_criterions DROP FOREIGN KEY FKilhg1u02m1765ltp3253wp7hn;
ALTER TABLE rbc_rubric_criterions DROP FOREIGN KEY FKt5dmnek3q7syuqck0uk9rw2hg;
ALTER TABLE rbc_criterion_ratings DROP KEY UK_funjjd0xkrmm5x300r7i4la83;

ALTER TABLE rbc_criterion DROP COLUMN created;
ALTER TABLE rbc_rating DROP COLUMN created;
ALTER TABLE rbc_criterion DROP COLUMN creatorId;
ALTER TABLE rbc_rating DROP COLUMN creatorId;
ALTER TABLE rbc_rubric DROP COLUMN `description`;
ALTER TABLE rbc_criterion DROP COLUMN modified;
ALTER TABLE rbc_rating DROP COLUMN modified;
ALTER TABLE rbc_rating DROP COLUMN ownerId;
ALTER TABLE rbc_criterion DROP COLUMN ownerType;
ALTER TABLE rbc_evaluation DROP COLUMN ownerType;
ALTER TABLE rbc_rating DROP COLUMN ownerType;
ALTER TABLE rbc_rubric DROP COLUMN ownerType;
ALTER TABLE rbc_tool_item_rbc_assoc DROP COLUMN ownerType;
ALTER TABLE rbc_criterion DROP COLUMN shared;
ALTER TABLE rbc_evaluation DROP COLUMN shared;
ALTER TABLE rbc_rating DROP COLUMN shared;
ALTER TABLE rbc_tool_item_rbc_assoc DROP COLUMN shared;
ALTER TABLE rbc_tool_item_rbc_assoc DROP COLUMN ownerId;
ALTER TABLE rbc_criterion_outcome MODIFY pointsAdjusted BIT(1) NULL;
ALTER TABLE rbc_criterion_outcome ALTER pointsAdjusted SET DEFAULT 0;
ALTER TABLE rbc_returned_criterion_out MODIFY pointsAdjusted BIT(1) NULL;
ALTER TABLE rbc_returned_criterion_out ALTER pointsAdjusted SET DEFAULT 0;
ALTER TABLE rbc_rubric MODIFY shared BIT(1) NULL;
ALTER TABLE rbc_rubric ALTER shared SET DEFAULT 0;
ALTER TABLE rbc_criterion ALTER weight SET DEFAULT null;
ALTER TABLE rbc_rubric MODIFY weighted BIT(1) NULL;
ALTER TABLE rbc_rubric ALTER weighted SET DEFAULT 0;
DROP INDEX rbc_tool_item_owner ON rbc_tool_item_rbc_assoc;
CREATE INDEX rbc_tool_item_owner ON rbc_tool_item_rbc_assoc (toolId, itemId, siteId);

-- this migrates the data from the link tables
UPDATE rbc_criterion rc JOIN rbc_rubric_criterions rrc ON rc.id = rrc.criterions_id SET rc.rubric_id = rrc.rbc_rubric_id, rc.order_index = rrc.order_index WHERE rc.rubric_id is NULL OR rc.order_index is NULL;
UPDATE rbc_rating rc JOIN rbc_criterion_ratings rcr ON rc.id = rcr.ratings_id SET rc.criterion_id = rcr.rbc_criterion_id, rc.order_index = rcr.order_index WHERE rc.criterion_id is NULL OR rc.order_index is NULL;
-- once the above conversion is run successfully then the following tables can be dropped
-- DROP TABLE rbc_criterion_ratings;
-- DROP TABLE rbc_rubric_criterions;
-- SAK-46178 END

-- SAK-46257 START
ALTER TABLE CONV_POSTS ADD DEPTH INT DEFAULT null NULL;
ALTER TABLE CONV_TOPIC_STATUS ADD POSTED BIT DEFAULT 0 NULL;
ALTER TABLE CONV_TOPICS ADD DUE_DATE datetime DEFAULT null NULL;
ALTER TABLE CONV_TOPICS ADD HIDE_DATE datetime DEFAULT null NULL;
ALTER TABLE CONV_TOPICS ADD LOCK_DATE datetime DEFAULT null NULL;
ALTER TABLE CONV_TOPICS ADD SHOW_DATE datetime DEFAULT null NULL;
ALTER TABLE CONV_POSTS ADD HOW_ACTIVE INT DEFAULT null NULL;
ALTER TABLE CONV_COMMENTS ADD TOPIC_ID VARCHAR(36) NOT NULL;
ALTER TABLE CONV_POSTS ADD NUMBER_OF_THREAD_REACTIONS INT DEFAULT null NULL;
ALTER TABLE CONV_POSTS ADD NUMBER_OF_THREAD_REPLIES INT DEFAULT null NULL;
ALTER TABLE CONV_POSTS ADD PARENT_THREAD_ID VARCHAR(36) NULL;
ALTER TABLE CONV_TOPICS ADD MUST_POST_BEFORE_VIEWING BIT DEFAULT 0 NULL;

CREATE INDEX conv_topics_site_creator_idx ON CONV_TOPICS (SITE_ID, CREATOR);
CREATE INDEX conv_posts_parent_thread_idx ON CONV_POSTS (PARENT_THREAD_ID);
CREATE INDEX conv_posts_topic_creator_idx ON CONV_POSTS (TOPIC_ID, CREATOR);
CREATE INDEX conv_comments_topic_idx ON CONV_COMMENTS (TOPIC_ID);

ALTER TABLE CONV_COMMENTS DROP FOREIGN KEY FK5ivsmxyitqpbm7pmdnu3lnmyi;
ALTER TABLE CONV_POSTS DROP FOREIGN KEY FKc21ukywsqsqilxlsdrg4x6qka;
ALTER TABLE CONV_USER_STATISTICS DROP FOREIGN KEY FKi9pfkqq0396p0kl718e9mrakk;
ALTER TABLE CONV_POST_REACTION_TOTALS DROP FOREIGN KEY FKirwlickqy5sf8o9ejk1qkuit6;
ALTER TABLE CONV_TOPIC_REACTIONS DROP FOREIGN KEY FKpwv7vrkag66g9kq6gghtc4uy1;
ALTER TABLE CONV_POSTS DROP FOREIGN KEY FKqaspmpv6ull7whideia5i2cnb;
ALTER TABLE CONV_TOPIC_REACTION_TOTALS DROP FOREIGN KEY FKqu7eyh63vtkowyqoqa9xy7wmq;
ALTER TABLE CONV_POST_REACTIONS DROP FOREIGN KEY FKqv38yghf2km7vq1i717xywih6;
-- SAK-46257 END

-- SAK-47231 START
ALTER TABLE CONV_POST_STATUS MODIFY POST_ID VARCHAR(36);
ALTER TABLE CONV_POST_STATUS MODIFY TOPIC_ID VARCHAR(36);
ALTER TABLE CONV_TOPIC_STATUS MODIFY TOPIC_ID VARCHAR(36);
-- SAK-47231 END
