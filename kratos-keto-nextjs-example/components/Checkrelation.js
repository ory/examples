import React, { useState } from "react";
import axios from "axios";
function CheckRelationtuple() {
  const [relation, setRelation] = useState({
    ObjectName: "",
    RelationName: "",
    SubjectName: "",
  });
  const [response, setResponse] = useState({});
  const handleChange = (e) => {
    const { name, value } = e.target;
    setRelation({
      ...relation,
      [name]: value,
    });
  };

  const handleClick = async (e) => {
    e.preventDefault();
    const { ObjectName, RelationName, SubjectName } = relation;
    if (ObjectName && RelationName && SubjectName) {
      const data = {
        object: ObjectName,
        relation: RelationName,
        subject: SubjectName,
      };
      const empty = {
        ObjectName: "",
        RelationName: "",
        SubjectName: "",
      };
      try {
        const res = await axios.post(
          "http://localhost:4000/checkrelation",
          data
        );
        console.log(res.data.allowed);
        setResponse({
          ...res.data,
        });
        setRelation({
          ...empty,
        });
      } catch (e) {
        console.log(e);
      }
    }
  };

  return (
    <div className="flex flex-col   max-w-6xl border-yellow-600 border border-2 rounded-md mt-5">
      <h1 className="text-center p-3 bg-gray-900 text-white">CHECK RELATION</h1>
      <div className=" flex justify-between  items-center mx-auto  container p-5 ">
        <form className="space-y-4">
          <div className="flex whitespace-nowrap items-center">
            <label>Object name</label>
            <input
              type="text"
              name="ObjectName"
              value={relation.ObjectName}
              onChange={(e) => handleChange(e)}
              className=" ml-4 border max-w-sm border-blue-300 p-2  rounded-md"
            />
          </div>
          <div className="flex whitespace-nowrap items-center">
            <label>Relation</label>
            <input
              type="text"
              onChange={(e) => handleChange(e)}
              name="RelationName"
              value={relation.RelationName}
              className="border ml-12 max-w-sm border-blue-300 p-2  rounded-md"
            />
          </div>
          <div className="flex whitespace-nowrap items-center">
            <label>Subject name</label>
            <input
              type="text"
              onChange={(e) => handleChange(e)}
              name="SubjectName"
              value={relation.SubjectName}
              className="border max-w-sm ml-3 border-blue-300 p-2 rounded-md"
            />
          </div>
          <button
            className="px-4 py-2 bg-green-500 rounded-md mt-3"
            onClick={handleClick}
          >
            check relation tuple
          </button>
        </form>
        {
          <h1>
            {response.allowed
              ? response.allowed === true
                ? "allowed"
                : ""
              : response.allowed === false
              ? "not allowed"
              : ""}
          </h1>
        }
      </div>
    </div>
  );
}

export default CheckRelationtuple;
