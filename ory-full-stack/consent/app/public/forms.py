from wtforms import Form
from wtforms import StringField
from wtforms import validators


class Oauth2CreateForm(Form):
    app_name = StringField('App Name', [validators.DataRequired()], render_kw={"placeholder": "App Name"})
    description = StringField(
        'App Description', [validators.DataRequired()], render_kw={"placeholder": "App Description"}
    )
    website_url = StringField('Website URL', [validators.URL()], render_kw={"placeholder": "WebSite URL"})
    callback_url = StringField('Callback URL', [validators.URL()], render_kw={"placeholder": "Callback URL"})


class LoginForm(Form):
    login_challenge = StringField('Login Challenge', [validators.DataRequired()])


class ConsentForm(Form):
    consent_challenge = StringField('Login challenge', [validators.DataRequired()])
    submit = StringField('Submit', [validators.DataRequired()])
