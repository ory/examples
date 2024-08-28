package com.github.chistousov.write_and_read_backend.jacoco_ignore;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * Marking with this annotation, we ignore code coverage by JaCoCo tests for a
 * class or method.
 * Помечая данной аннотацией, мы игнорируем для класса или метода покрытие кода
 * тестами JaCoCo
 */
@Documented
@Retention(RUNTIME)
@Target({ TYPE, METHOD })
public @interface ExcludeFromJacocoGeneratedReport {
}
