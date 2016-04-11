CREATE OR REPLACE VIEW ISSUE_OUTLINE_VIEW AS
 SELECT
   A.USER_NAME,
   A.REPOSITORY_NAME,
   A.ISSUE_ID,
   NVL(B.COMMENT_COUNT, 0) + NVL(C.COMMENT_COUNT, 0) AS COMMENT_COUNT
 FROM ISSUE A
 LEFT OUTER JOIN (
   SELECT USER_NAME, REPOSITORY_NAME, ISSUE_ID, COUNT(COMMENT_ID) AS COMMENT_COUNT FROM ISSUE_COMMENT
   WHERE ACTION IN ('comment', 'close_comment', 'reopen_comment')
   GROUP BY USER_NAME, REPOSITORY_NAME, ISSUE_ID
 ) B
 ON (A.USER_NAME = B.USER_NAME AND A.REPOSITORY_NAME = B.REPOSITORY_NAME AND A.ISSUE_ID = B.ISSUE_ID)
 LEFT OUTER JOIN (
   SELECT USER_NAME, REPOSITORY_NAME, ISSUE_ID, COUNT(COMMENT_ID) AS COMMENT_COUNT FROM COMMIT_COMMENT
   GROUP BY USER_NAME, REPOSITORY_NAME, ISSUE_ID
 ) C
 ON (A.USER_NAME = C.USER_NAME AND A.REPOSITORY_NAME = C.REPOSITORY_NAME AND A.ISSUE_ID = C.ISSUE_ID);
