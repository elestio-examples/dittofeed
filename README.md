# Dittofeed CI/CD pipeline

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/dittofeed"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Dittofeed with CI/CD on Elestio

<img src="dittofeed.png" style='width: 100%;'/>
<br/>
<br/>

# Once deployed ...

You can open Dittofeed UI here:

    URL: https://[CI_CD_DOMAIN]
    email: [ADMIN_EMAIL]
    password: [ADMIN_PASSWORD]

You can open pgAdmin web UI here:

    URL: https://[CI_CD_DOMAIN]:7443
    email: [ADMIN_EMAIL]
    password: [ADMIN_PASSWORD]

# IMPORTANT

Before you deploy your application, make sure you have a Segment.io AND a SendGrid account.

If not, you won't be able to send emails and collect events
