#include <ruby.h>

VALUE m_memorandum                   = Qnil;
VALUE m_memorandum__instance_methods = Qnil;

ID sym_include               = Qnil;
ID sym_instance_variable_get = Qnil;
ID sym_instance_variable_set = Qnil;

void Init_memorandum();
void initialize_symbols();
void setup_memorandum_module();
void setup_memorandum__instance_methods_module();
VALUE method_memorandum__self__extended(VALUE self, VALUE base);
VALUE method_memorandum__instance_methods__memorandum_fetch(VALUE self, VALUE name, VALUE default_value);

void Init_memorandum() {
  initialize_symbols();
  setup_memorandum_module();
  setup_memorandum__instance_methods_module();
}

void initialize_symbols() {
  sym_include               = rb_intern("include");
  sym_instance_variable_get = rb_intern("instance_variable_get");
  sym_instance_variable_set = rb_intern("instance_variable_set");
}

void setup_memorandum_module() {
  m_memorandum = rb_define_module("Memorandum");

  rb_define_singleton_method(m_memorandum, "extended", method_memorandum__self__extended, 1);
}

void setup_memorandum__instance_methods_module() {
  m_memorandum__instance_methods = rb_define_module_under(m_memorandum, "InstanceMethods");

  rb_define_method(m_memorandum__instance_methods, "memorandum_fetch", method_memorandum__instance_methods__memorandum_fetch, 2);
}

VALUE method_memorandum__self__extended(VALUE self, VALUE base) {
  rb_funcall(base, sym_include, 1, m_memorandum__instance_methods);

  return Qnil;
}

VALUE method_memorandum__instance_methods__memorandum_fetch(VALUE self, VALUE name, VALUE default_value) {
  VALUE current_value = rb_funcall(self, sym_instance_variable_get, 1, name);

  if (current_value != Qnil) return current_value;

  rb_funcall(self, sym_instance_variable_set, 2, name, default_value);

  return default_value;
}
