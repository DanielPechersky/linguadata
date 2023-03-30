D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib" # Directory name
  # check "Gemfile" # File name

  # library "pathname", "set" # Standard libraries
  # library "strong_json"           # Gems

  configure_code_diagnostics(D::Ruby.strict)
end

# target :test do
#   signature "sig", "sig-private"
#
#   check "test"
#
#   # library "pathname", "set"       # Standard libraries
# end
