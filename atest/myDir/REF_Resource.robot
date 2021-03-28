*** Setting ***
Library           SeleniumLibrary    run_on_failure=Nothing    implicit_wait=0.2 seconds
Library           Collections
Library           OperatingSystem
Library           DateTime

*** Variable ***
${SERVER}         10.2.112.101:9001
${BROWSER}        chrome
${REMOTE_URL}     ${NONE}
${DESIRED_CAPABILITIES}    ${NONE}
${ROOT}           http://${SERVER}
${FRONT_PAGE}     ${ROOT}/ref/
${SPEED}          0

*** Keyword ***
Open Browser To Start Page
    [Documentation]    This keyword also tests 'Set Selenium Speed' and 'Set Selenium Timeout'
    ...    against all reason.
    ${default speed}    ${default timeout}=    Open Browser To Start Page Without Testing Default Options
    # FIXME: We shouldn't test anything here. If this stuff isn't tested elsewhere, new *tests* needs to be added.
    # FIXME: The second test below verifies a hard coded return value!!?!
    Should Be Equal    ${default speed}    0 seconds
    Should Be Equal    ${default timeout}    5 seconds

Open Browser To Start Page Without Testing Default Options
    [Documentation]    Open Browser To Start Page Without Testing Default Options
    Open Browser    ${FRONT PAGE}    ${BROWSER}    remote_url=${REMOTE_URL}    desired_capabilities=${DESIRED_CAPABILITIES}
    ${orig speed} =    Set Selenium Speed    ${SPEED}
    ${orig timeout} =    Set Selenium Timeout    10 seconds
    [Return]    ${orig speed}    5 seconds

Go to Front Page
    [Documentation]    Goes to front page
    Go To    ${FRONT PAGE}

Go To Page "${relative url}"
    [Documentation]    Goes to page
    Go To    ${ROOT}/${relative url}

Login Page Should Be Open
    Title Should Be    Login Page

Wait For Readiness
    [Arguments]    ${elem}
    Wait Until Page Contains Element    ${elem}
    Wait For Condition    return document.readyState=="complete"

Go To Login Page
    Go To    ${LOGIN URL}
    Login Page Should Be Open

Input Username
    [Arguments]    ${username}
    Wait For Readiness    username
    Input Text    username    ${username}

Input Password
    [Arguments]    ${password}
    Wait For Readiness    password
    Input Text    password    ${password}

Submit Credentials
    Wait For Readiness    login
    Click Button    login

Input Search
    [Arguments]    ${search}
    Wait For Readiness    formConteudo:mesAnoId
    Input Text    formConteudo:mesAnoId    ${search}

Submit Search
    Wait For Readiness    formConteudo:pesquisar
    Click Button    formConteudo:pesquisar

Set ${level} Loglevel
    [Documentation]    Sets loglevel
    Set Log Level    ${level}

Verify Location Is "${relative url}"
    [Documentation]    Verifies location
    Wait Until Keyword Succeeds    5    1    Location Should Be    ${ROOT}/${relative url}

Set Global Timeout
    [Arguments]    ${timeout}
    ${previous} =    Set Selenium timeout    ${timeout}
    Set Suite Variable    ${PREVIOUS TIMEOUT}    ${previous}

Restore Global Timeout
    Set Selenium timeout    ${PREVIOUS TIMEOUT}
