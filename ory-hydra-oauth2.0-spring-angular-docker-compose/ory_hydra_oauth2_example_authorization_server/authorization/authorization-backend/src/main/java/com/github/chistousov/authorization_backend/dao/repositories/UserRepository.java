package com.github.chistousov.authorization_backend.dao.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.github.chistousov.authorization_backend.dao.entities.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

  @Procedure("User.createUser")
  Long createUser(
      @Param("login") String login,
      @Param("password") String password,
      @Param("org_name") String orgName);

}
