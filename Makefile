EBIN_DIR := ebin
SRC_DIR := src
EXAMPLES_DIR := examples

DEBUG := $(EBIN_DIR)/.debug

all: output_dir
	@if [ -f $(DEBUG) ]; then make clean output_dir; rm -f $(DEBUG); fi
	@erl -noinput +B -eval 'make:files(filelib:wildcard("$(SRC_DIR)/*.erl")), halt(0).'

debug: output_dir
	@if [ ! -f $(DEBUG) ]; then make clean output_dir; touch $(DEBUG); fi
	@erl -noinput +B \
		-eval 'case make:files(filelib:wildcard("$(SRC_DIR)/*.erl"), [debug_info, {d, log_debug}]) of \
		         up_to_date -> halt(0); \
		         error      -> halt(1)  \
					 end.'

clean:
	@rm -rf $(EBIN_DIR)/* $(DEBUG)
	@rm -f erl_crash.dump

example: output_dir
	@erl -noinput +B -eval 'make:files(filelib:wildcard("$(EXAMPLES_DIR)/*.erl")), halt(0).'

output_dir:
	@mkdir -p $(EBIN_DIR)
	@cp $(SRC_DIR)/*.app $(EBIN_DIR)/
