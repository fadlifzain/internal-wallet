class Team < Account
    has_many :users, class_name: "User", foreign_key: "team_id"
end
