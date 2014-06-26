# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard :rspec do
	watch(%r{^spec/.+_spec\.rb$})

	watch(%r{^lib/(.+)\.rb$}) do
		|m| "spec/lib/#{m[1]}_spec.rb"
	end

	watch('spec/spec_helper.rb') do
		"spec"
	end

	# Specs for Rails files
	watch(%r{^app/(.+)\.rb$}) do
		|m| "spec/#{m[1]}_spec.rb"
	end

	watch(%r{^app/(.*)(\.erb|\.haml|\.slim|\.jbuilder)$}) do
		|m| "spec/#{m[1]}#{m[2]}_spec.rb"
	end

	watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do
		|m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"]
	end

	watch(%r{^spec/support/(.+)\.rb$}) do
		"spec"
	end

	watch('config/routes.rb') do
		"spec/routing"
	end

	watch('app/controllers/application_controller.rb') do
		"spec/controllers"
	end

	# Capybara features specs
	watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$}) do
		|m| "spec/features/#{m[1]}_spec.rb"
	end

	# Turnip features and steps
	watch(%r{^spec/acceptance/(.+)\.feature$})
	watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do
		|m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
	end
end
