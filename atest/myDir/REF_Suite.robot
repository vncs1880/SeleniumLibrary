*** Settings ***
Suite Setup       Open Browser To Start Page
Suite Teardown
Resource          REF_Resource.robot
Library           Dialogs
Library           myLibrary.py
Library           String
Resource          credentials.robot

*** Variables ***
${search_key}     03/2015
@{search_period_small_sample}    02/2014    03/2014    04/2014    05/2014
@{search_period}    02/2014    03/2014    04/2014    05/2014    06/2014    07/2014    08/2014    09/2014    10/2014    11/2014    12/2014    01/2015    02/2015    03/2015    04/2015    05/2015    06/2015
...               07/2015    08/2015    09/2015    10/2015    11/2015    12/2015    01/2016    02/2016    03/2016    04/2016    05/2016    06/2016    07/2016    08/2016    09/2016    10/2016    11/2016
...               01/2017    04/2017    05/2017    06/2017    07/2017    08/2017    09/2017    10/2017    11/2017    12/2017    01/2018    02/2018    03/2018    04/2018    05/2018    06/2018    07/2018
...               08/2018    09/2018    10/2018    11/2018    12/2018    01/2019    02/2019    03/2019    04/2019    05/2019    06/2019    07/2019    08/2019    09/2019    10/2019    11/2019    12/2019
...               01/2020    02/2020    03/2020    04/2020    05/2020    06/2020    07/2020    08/2020    09/2020

*** Test Cases ***
Valid Login Interactive
    ${user}    Get Value From User    User:    ${ref_user}
    ${password}    Get Value From User    Password:    ${pwd}    hidden=True
    Input Username    ${ref_user}
    Input Password    ${password}
    Submit Credentials

Download Time Tables
    [Setup]    Valid Login
    Set Screenshot Directory    \REF_pics\
    Open REF And Get All Tables    @{search_keys_small_sample}
    [Teardown]    Close All Browsers

Upload Manual Entries
    [Setup]    Valid Login
    FOR    ${period}    IN    @{search_period_small_sample}
    @{changes_todo}    Open Excel And Get To Do List    ${period}
    FOR    ${change}    IN    @{changes_todo}
        #    {changes_todo} = [['13:34', 'FFFF0000', '6 -Terça-feira', 'Entrada', 'xpath://*[@id="formCo...0:j_id307"]'], ['15:11', 'FFFF0000', '26 -Seg
        Click Element    ${change}[4]
        Create Manual Entry    ${change}    ${period}
    END
    END
    [Teardown]    Close All Browsers

*** Keywords ***
Search Period
    [Arguments]    ${ano_mes}
    Input Search    ${ano_mes}
    Submit Search
    Wait Until Keyword Succeeds    15    2    Wait Until Element Contains    formConteudo:j_id267:j_id268    ${ano_mes}
    Wait For Condition    return document.readyState=="complete"
    Wait Until Element Is Visible    formConteudo:j_id267:opRelatorio:tb

Valid Login
    Input Username    ${ref_user}
    Input Password    ${password}
    Submit Credentials

Open REF And Get All Tables
    [Arguments]    @{search_keys_list}
    FOR    ${ano_mes}    IN    @{search_keys_list}
        Search Period    ${ano_mes}
        #    ${estilo}    Get Element Attribute    xpath://*[@id="formConteudo:j_id267:opRelatorio:j_id379"]/span    style
        ${str}    Replace String    ${ano_mes}    /    _
        Capture Element Screenshot    xpath://*[@id="formConteudo:j_id267:opRelatorio:j_id379"]/span    ${str}.png
        ${page_html}    Get Source
        Get Page Tables    ${ano_mes}    ${page_html}
    END

Open Excel And Get To Do List
    [Arguments]    ${ano_mes}
    Search Period    ${ano_mes}
    ${res}    Get Changes    ${ano_mes}
    Return From Keyword    ${res}

Create Manual Entry
    [Arguments]    ${todo}    ${ano_mes}
    #    todo = ['13:34', 'FFFF0000', '6 -Terça-feira', 'Entrada', 'xpath://*[@id="formCo...0:j_id307"]']
    Wait Until Element Is Enabled    formInclusao:j_id549:1
    Wait Until Element Is Visible    formInclusao:j_id549:1
    Click Element    formInclusao:j_id549:1
    # Set Local Variable    ${record_type}    formInclusao:registrosInclusao:0:j_id582
    ${record_type}    Set Variable If    ${{'${todo}[3]' == 'Saída'}}    formInclusao:registrosInclusao:0:j_id584    formInclusao:registrosInclusao:0:j_id582
    Wait Until Element Is Enabled    ${record_type}
    Press Keys    ${record_type}    ${todo}[0]
    Textfield Should Contain    ${record_type}    ${todo}[0]
    # Click Element    formInclusao:salvar
    Wait Until Element Is Visible    formInclusao:registrosSelecionados:tb
    ${clean_period}    Replace String    ${ano_mes}    /    -
    ${clean_timestamp}    Replace String    ${todo}[0]    :    -
    Set Screenshot Directory    \REF_pics\
    Capture Element Screenshot    formInclusao:registrosInclusao    ${clean_period}-${todo}[2]-${todo}[3]-${clean_timestamp}.png
    Click Element    formInclusao:j_id631
    Wait Until Element Is Visible    formConteudo:j_id267:opRelatorio:tb
