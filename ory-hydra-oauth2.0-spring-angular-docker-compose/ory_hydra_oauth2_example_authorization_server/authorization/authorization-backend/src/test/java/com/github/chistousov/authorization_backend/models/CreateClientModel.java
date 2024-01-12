package com.github.chistousov.authorization_backend.models;

import java.util.List;

public class CreateClientModel {
  private String client_id;
  private List<String> redirect_uris;
  private String client_secret;
  private List<String> grant_types;
  private List<String> response_types;
  private String scope;

  public String getClient_id() {
    return client_id;
  }

  public void setClient_id(String client_id) {
    this.client_id = client_id;
  }

  public List<String> getRedirect_uris() {
    return redirect_uris;
  }

  public void setRedirect_uris(List<String> redirect_uris) {
    this.redirect_uris = redirect_uris;
  }

  public String getClient_secret() {
    return client_secret;
  }

  public void setClient_secret(String client_secret) {
    this.client_secret = client_secret;
  }

  public List<String> getGrant_types() {
    return grant_types;
  }

  public void setGrant_types(List<String> grant_types) {
    this.grant_types = grant_types;
  }

  public List<String> getResponse_types() {
    return response_types;
  }

  public void setResponse_types(List<String> response_types) {
    this.response_types = response_types;
  }

  public String getScope() {
    return scope;
  }

  public void setScope(String scope) {
    this.scope = scope;
  }

}
