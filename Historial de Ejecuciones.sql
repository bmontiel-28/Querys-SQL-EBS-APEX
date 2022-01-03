SELECT
    pt.user_concurrent_program_name user_concurrent_program_name,
    frt.responsibility_name         responsabilidad,
    r.request_date,
    u.user_name                     requestor,
    r.completion_text,
    r.argument_text
FROM
    fnd_concurrent_programs_tl pt,
    fnd_concurrent_programs    pb,
    fnd_user                   u,
    fnd_printer_styles_tl      s,
    fnd_concurrent_requests    r,
    fnd_responsibility_tl      frt
WHERE
        pb.application_id = r.program_application_id
    AND pb.concurrent_program_id = r.concurrent_program_id
    AND pb.application_id = pt.application_id
    AND pb.concurrent_program_id = pt.concurrent_program_id
    AND pt.language = 'ESA'
    AND u.user_id = r.requested_by
    AND s.printer_style_name (+) = r.print_style
    AND s.language (+) = 'ESA'
    AND pt.user_concurrent_program_name = :p_nom_concurrente --'XXMRP Accounts Payable Trial Balance'
       --and TRUNC (r.request_date) >= TO_DATE ('06/09/2020','DD/MM/YYYY')
    AND frt.responsibility_id = r.responsibility_id
    AND frt.language = 'ESA'
ORDER BY
    r.request_date DESC
