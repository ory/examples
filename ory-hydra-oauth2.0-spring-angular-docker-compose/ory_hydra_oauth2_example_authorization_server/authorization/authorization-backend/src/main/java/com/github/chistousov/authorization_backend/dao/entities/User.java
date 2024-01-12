package com.github.chistousov.authorization_backend.dao.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@NamedStoredProcedureQuery(name = "User.createUser", procedureName = "horns_and_hooves.add_user", parameters = {
    @StoredProcedureParameter(name = "login", type = String.class, mode = ParameterMode.IN),
    @StoredProcedureParameter(name = "password", type = String.class, mode = ParameterMode.IN),
    @StoredProcedureParameter(name = "org_name", type = String.class, mode = ParameterMode.IN),
    @StoredProcedureParameter(name = "user_id", type = Long.class, mode = ParameterMode.OUT)
})

@NamedStoredProcedureQuery(name = "User.getUserByLogin", procedureName = "horns_and_hooves.get_login", resultClasses = {
    User.class }, parameters = {
        @StoredProcedureParameter(mode = ParameterMode.REF_CURSOR, type = void.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, type = String.class)
    })

@NoArgsConstructor
@Getter
@Builder
@EqualsAndHashCode(exclude = { "id", "password" })
@AllArgsConstructor
@Entity
public class User {

  @Id
  @Column(name = "id")
  private Long id;

  @Column(name = "login")
  private String login;

  @Column(name = "password")
  private String password;

  public void setPassword(String password) {
    this.password = password;
  }

  @Column(name = "org_name")
  private String orgName;

}
