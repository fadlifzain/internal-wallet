class User < Account
    belongs_to :team, optional: true
end
