use base.nu

export def questions-list [] {
  base query-db "SELECT
                    q.question_id,
                    question_name,
                    answer,
                    detail,
                    parent_id,
                    CASE
                        WHEN c.question_id IS NULL THEN 0
                        ELSE 1
                    END is_current,
                    is_resolved,
                    date_created,
                    date_modified
                FROM
                    question q
                    LEFT JOIN current c ON q.question_id = c.question_id
                ORDER BY is_current DESC, date_modified desc" | base format-dates | base format-bool is_current | base format-bool is_resolved | base trim-string answer 20 | base trim-string detail 20
}

export def tests-list [] {
  base query-db "SELECT
                        t.test_id,
                        t.question_id,
                        t.hypothesis,
                        t.result,
                        CASE
                            WHEN c.test_id IS NULL THEN 0
                            ELSE 1
                        END is_current,
                        t.is_refuted,
                        t.is_tested,
                        t.date_modified,
                        t.date_created
                    FROM
                        test t
                        LEFT JOIN current c ON t.test_id = c.test_id
                        LEFT JOIN current cq ON t.question_id = cq.question_id
                    ORDER BY
                        is_current DESC,
                        date_modified DESC" | base format-dates | base format-bool is_current | base format-bool is_tested | base format-bool is_refuted | base trim-string result 100
}

export def refs-list [] {
  base query-db "SELECT
                        reference_id,
                        reference_name,
                        reference_url,
                        question_id,
                        description,
                        date_created,
                        date_modified
                    FROM
                        reference order by date_modified desc" | base format-dates | base trim-string reference_url 20 | base trim-string description 20
}
