function randomized_variables(fig)

% add noise to locations, velocities and lambda
locations=fig.UserData.locations;
fig.UserData.lambda_noisy=...
    fig.UserData.c/(fig.UserData.f0+randn*fig.UserData.frequency_error);
fig.UserData.locations_noisy=locations+...
    randn(size(locations))*fig.UserData.location_error;
fig.UserData.velocities_noisy=fig.UserData.velocities+...
    randn(size(locations))*fig.UserData.velocity_error;
end