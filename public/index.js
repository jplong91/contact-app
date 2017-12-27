/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      // message: "Welcome to Vue.js!"
      contacts: [],
      nameInclude: "",
      nameAttribute: "last_name"
    };
  },
  created: function() {
    axios.get("/contacts").then(
      function(response) {
        this.contacts = response.data;
      }.bind(this)
    );
  },
  methods: {
    changeNameAttribute: function(inputAttribute) {
      this.nameAttribute = inputAttribute;
    },
    isNamePresent: function(name) {
      return name.first_name
        .toLowerCase()
        .includes(this.nameInclude.toLowerCase());
    }
  },
  computed: {
    sortedContacts: function() {
      return this.contacts.sort(
        function(person1, person2) {
          return person1[this.nameAttribute] > person2[this.nameAttribute];
        }.bind(this)
      );
    }
  }
};

var ContactPage = {
  template: "#contact-page",
  data: function() {
    return {
      contact: []
    };
  },
  created: function() {
    axios
      .get("/contacts/" + this.$route.params.id)
      .then(
        function(response) {
          this.contact = response.data;
        }.bind(this)
      )
      .catch(function(error) {
        console.log(error);
      });
  },
  methods: {},
  computed: {}
};

var SignupPage = {
  template: "#signup-page",
  data: function() {
    return {
      name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      };
      axios
        .post("/users", params)
        .then(function(response) {
          router.push("/login");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var LoginPage = {
  template: "#login-page",
  data: function() {
    return {
      email: "",
      password: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        auth: { email: this.email, password: this.password }
      };
      axios
        .post("/user_token", params)
        .then(function(response) {
          axios.defaults.headers.common["Authorization"] =
            "Bearer " + response.data.jwt;
          localStorage.setItem("jwt", response.data.jwt);
          router.push("/");
        })
        .catch(
          function(error) {
            this.errors = ["Invalid email or password."];
            this.email = "";
            this.password = "";
          }.bind(this)
        );
    }
  }
};

var LogoutPage = {
  created: function() {
    axios.defaults.headers.common["Authorization"] = undefined;
    localStorage.removeItem("jwt");
    router.push("/");
  }
};

var NewContact = {
  template: "#new-contact",
  data: function() {
    return {
      firstName: "",
      lastName: "",
      email: "",
      phoneNumber: "",
      bio: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        first_name: this.firstName,
        last_name: this.lastName,
        email: this.email,
        phone_number: this.phoneNumber,
        bio: this.bio
      };
      axios
        .post("/contacts", params)
        .then(function(response) {
          console.log(response);
          router.push("/#/");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var EditContact = {
  template: "#edit-contact",
  data: function() {
    return {
      contact: [],
      firstName: "",
      lastName: "",
      email: "",
      phoneNumber: "",
      bio: "",
      errors: []
    };
  },
  mounted: function() {
    axios
      .get("/contacts/" + this.$route.params.id)
      .then(
        function(response) {
          console.log(response);
          this.contact = response.data;
        }.bind(this)
      )
      .catch(function(error) {
        console.log(error);
      });
  },
  methods: {
    submit: function() {
      var params = {
        first_name: this.firstName,
        last_name: this.lastName,
        email: this.email,
        phone_number: this.phoneNumber,
        bio: this.bio
      };
      axios
        .patch("/contacts/" + this.contact.id, params)
        .then(
          function(response) {
            router.push("/contacts/" + this.contact.id);
          }.bind(this)
        )
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var router = new VueRouter({
  routes: [
    { path: "/", component: HomePage },
    { path: "/contacts/:id", component: ContactPage },
    { path: "/contacts/:id/edit", component: EditContact },
    { path: "/contacts/new", component: NewContact },
    { path: "/signup", component: SignupPage },
    { path: "/login", component: LoginPage },
    { path: "/logout", component: LogoutPage }
  ],
  scrollBehavior: function(to, from, savedPosition) {
    return { x: 0, y: 0 };
  }
});

var app = new Vue({
  el: "#app",
  router: router,
  created: function() {
    var jwt = localStorage.getItem("jwt");
    if (jwt) {
      axios.defaults.headers.common["Authorization"] = jwt;
    }
  }
});
