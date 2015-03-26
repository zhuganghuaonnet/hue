## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.    See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

<%!
  from desktop import conf
  from django.utils.translation import ugettext as _
  from desktop.views import commonheader, commonfooter
  from useradmin.password_policy import is_password_policy_enabled, get_password_hint
%>

${ commonheader("Welcome to Hue", "login", user, "50px", True) | n,unicode }

<link rel="stylesheet" href="${ static('desktop/ext/chosen/chosen.min.css') }">
<style type="text/css">
  body {
    background-color: #e7ebee;
  }

  @-webkit-keyframes spinner {
    from {
      -webkit-transform: rotateY(0deg);
    }
    to {
      -webkit-transform: rotateY(-360deg);
    }
  }

  #logo {
    background: none repeat scroll 0 0 #34495e;
    color: #fff;
    display: block;
    font-size: 2em;
    font-weight: 400;
    padding: 35px 0;
    text-align: center;
    text-transform: uppercase;
  }

  #logo > img {
    display: block;
    height: 40px;
    margin: 0 auto;
  }


  #logo.waiting {
    -webkit-animation-name: spinner;
    -webkit-animation-timing-function: linear;
    -webkit-animation-iteration-count: infinite;
    -webkit-animation-duration: 2s;
    -webkit-transform-style: preserve-3d;
  }

  .login-content {
    width: 360px;
    display: block;
    margin-left: auto;
    margin-right: auto;
    background: #fff;
    border-radius: 0 0 3px 3px;
    background-clip: padding-box;
    border: 1px solid #e1e1e1;
    border-bottom-width: 5px;
  }

  .login-content form {
    padding: 40px 25px;
  }

  .login-content .add-on {
    border: 1px solid #e7ebee;
    min-height: 38px;
    min-width: 30px;
    line-height: 38px;
    background-color: #FFF;
  }

  .login-content .add-on i {
    color: #efefef;
  }

  .input-prepend {
    width: 100%;
  }

  .login-content input {
    width: 230px;
    min-height: 38px;
    font-size: 13px;
    color: #555;
    border: 1px solid #e7ebee;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
  }

  .login-content .input-prepend.error input, .login-content .input-prepend.error .add-on {
    border-color: #e74c3c;
  }

  .login-content .input-prepend.error input {
    border-right-color: #e74c3c;
  }

  .login-content .input-prepend.error .add-on {
    border-left-color: #e74c3c;
  }

  .login-content input[type='submit'] {
    height: 44px;
    min-height: 44px;
    text-shadow: none;
    font-size: 1.125em;
    font-weight: 600;
    width: 300px;
    text-transform: uppercase;
    margin-top: 8px;
    color: #FFF;
    background-color: #3498db;
    border: none;
    padding: 6px 12px;
    border-bottom: 4px solid #2980b9;
    -webkit-transition: border-color 0.1s ease-in-out 0s, background-color 0.1s ease-in-out 0s;
    transition: border-color 0.1s ease-in-out 0s, background-color 0.1s ease-in-out 0s;
    outline: none;
    border-radius: 3px;
    background-clip: padding-box;
    background-image: none;
      margin-bottom: 0;
  }

  ul.errorlist {
    text-align: left;
    margin-bottom: 4px;
    margin-top: -4px;
  }

  .alert-error ul.errorlist {
    margin-top: 0;
  }

  ul.errorlist li {
    font-size: 13px;
    font-weight: normal;
    font-style: normal;
    padding-left: 10px;
    color: #c0392b;
  }

  .alert-error ul.errorlist li {
    padding-left: 0;
  }

  input.error {
    border-color: #e74c3c;;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
  }

  .chosen-single {
    min-height: 38px;
    text-align: left;
    font-size: 18px;
  }

  .chosen-single span {
    display: inline;
    line-height: 38px;
    vertical-align: middle;
  }

  .chosen-container-active.chosen-with-drop .chosen-single div b,
  .chosen-container-single .chosen-single div b {
    background-position-x: 1px;
    background-position-y: 10px;
  }

  .chosen-container-active.chosen-with-drop .chosen-single div b {
    background-position-x: -17px;
    background-position-y: 10px;
  }
</style>


<div class="container">
  <div class="row">
    <div class="login-content center">
      <div id="logo">
        <img src="${ static('desktop/img/login.png') }">
      </div>

      <form method="POST" action="${action}">
        ${ csrf_token(request) | n,unicode }

        %if first_login_ever:
          <div class="alert alert-block">
            ${_('Since this is your first time logging in, pick any username and password. Be sure to remember these, as')}
            <strong>${_('they will become your Hue superuser credentials.')}</strong>
            % if is_password_policy_enabled():
	          <p>${get_password_hint()}</p>
            % endif
          </div>
        %endif

        <div class="input-prepend
          % if backend_name == 'OAuthBackend':
            hide
          % endif
        ">
          <span class="add-on"><i class="fa fa-user"></i></span>
          ${ form['username'] | n,unicode }
        </div>

        ${ form['username'].errors | n,unicode }

        <div class="input-prepend
          % if backend_name in ('AllowAllBackend', 'OAuthBackend'):
            hide
          % endif
        ">
          <span class="add-on"><i class="fa fa-lock"></i></span>
          ${ form['password'] | n,unicode }
        </div>
        ${ form['password'].errors | n,unicode }

        %if active_directory:
        <div class="input-prepend">
          <span class="add-on"><i class="fa fa-globe"></i></span>
          ${ form['server'] | n,unicode }
        </div>
        %endif

        %if login_errors and not form['username'].errors and not form['password'].errors:
          <div class="alert alert-error">
            <strong><i class="fa fa-exclamation-triangle"></i> ${_('Error!')}</strong>
            % if form.errors:
              % for error in form.errors:
               ${ form.errors[error]|unicode,n }
              % endfor
            % endif
          </div>
        %endif
        %if first_login_ever:
          <input type="submit" class="btn btn-large btn-primary" value="${_('Create account')}"/>
        %else:
          <input type="submit" class="btn btn-large btn-primary" value="${_('Sign in')}"/>
        %endif
        <input type="hidden" name="next" value="${next}"/>
      </form>
    </div>
  </div>
</div>

<script src="${ static('desktop/ext/chosen/chosen.jquery.min.js') }" type="text/javascript" charset="utf-8"></script>
<script>
  $(document).ready(function () {
    $("#id_server").chosen({
      disable_search_threshold: 5,
      width: "90%",
      no_results_text: "${_('Oops, no database found!')}"
    });

    $("form").on("submit", function () {
      window.setTimeout(function () {
        $("#logo").addClass("waiting");
      }, 1000);
    });

    % if backend_name == 'AllowAllBackend':
      $('#id_password').val('password');
    % endif

    % if backend_name == 'OAuthBackend':
      $("input").css({"display": "block", "margin-left": "auto", "margin-right": "auto"});
      $("input").bind('click', function () {
        window.location.replace('/login/oauth/');
        return false;
      });
    % endif

    $("ul.errorlist").each(function () {
      $(this).prev().addClass("error");
    });
  });
</script>

${ commonfooter(messages) | n,unicode }
